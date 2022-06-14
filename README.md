# Armg

Add MySQL geometry type to Active Record.

[![Gem Version](https://badge.fury.io/rb/armg.svg)](https://badge.fury.io/rb/armg)
[![Build Status](https://github.com//armg/workflows/test/badge.svg?branch=master)](https://github.com/winebarrel/armg/actions)


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'armg'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install armg

## Usage

```ruby
require 'active_record'
require 'armg'

ActiveRecord::Base.establish_connection(adapter: 'mysql2', database: 'my_db')

ActiveRecord::Migration.create_table :geoms, options: 'ENGINE=MyISAM' do |t|
  t.geometry 'location', null: false
  t.index ['location'], name: 'idx_location', type: :spatial
end

class Geom < ActiveRecord::Base; end

wkt_parser = RGeo::WKRep::WKTParser.new(nil, support_ewkt: true)
point = wkt_parser.parse('SRID=4326;Point(-122.1 47.3)')
Geom.create!(location: point)

Geom.first
#=> #<Geom id: 1, location: #<RGeo::Cartesian::PointImpl:0x... "POINT (-122.1 47.3)">>
```

## Using WKT

```ruby
Armg.deserializer = Armg::WktDeserializer.new
Armg.serializer = Armg::WktSerializer.new

Geom.create!(location: 'Point(-122.1 47.3)')

Geom.first
#=> #<Geom id: 1, location: "Point (-122.1 47.3)">
```

## Using custom deserializer

```ruby
class CustomDeserializer
  def initialize
    factory = RGeo::Geographic.spherical_factory(srid: 0)
    @wkb_parser = RGeo::WKRep::WKBParser.new(factory, support_ewkb: true)
  end

  def deserialize(wkb)
    wkb_without_srid = wkb.b.slice(4..-1)
    @wkb_parser.parse(wkb_without_srid)
  end
end

Armg.deserializer = CustomDeserializer.new

Geom.take
#=> #<Geom id: 1, location: #<RGeo::Geographic::SphericalPointImpl:0x... "POINT (-122.1 47.3)">>
```

## Using custom serializer

```ruby
class CustomSerializer
  def initialize
    @wkt_parser = RGeo::WKRep::WKTParser.new(nil, support_ewkt: true)
    @wkb_generator = RGeo::WKRep::WKBGenerator.new(type_format: :ewkb, little_endian: true)
  end

  def serialize(value)
    if value.is_a?(String)
      value = @wkt_parser.parse(value)
    end

    srid = "\x00\x00\x00\x00"
    srid + @wkb_generator.generate(value)
  end
end

Armg.serializer = CustomSerializer.new

Geom.create!(id: 4, location: 'Point(-122.1 47.3)')
```

## Running tests

```sh
docker-compose up -d
bundle install
bundle exec appraisal install
bundle exec appraisal ar61 rake
# bundle exec appraisal ar60 rake
# ARMG_TEST_MYSQL_PORT=10057 bundle exec appraisal ar61 rake # MySQL 5.7
# ARMG_TEST_MYSQL_PORT=10057 ARMG_TEST_MYSQL_ENGINE=InnoDB bundle exec appraisal ar61 rake
```

## Using with [Ridgepole](https://github.com/winebarrel/ridgepole)

You need to extend the TableDefinition class.

```ruby
# ridgepole-geo.rb
module TableDefinitionExtForGeometry
  def geometry(*args)
    options = args.extract_options!
    column_names = args
    column_names.each { |name| column(name, :geometry, options) }
  end
end
Ridgepole::DSLParser::TableDefinition.prepend(TableDefinitionExtForGeometry)

module DiffExtForGeometry
  def normalize_index_options!(opts)
    super
    opts.delete(:length) if opts[:type] == :spatial
  end
end
Ridgepole::Diff.prepend(DiffExtForGeometry)
```

```sh
$ ridgepole -c 'mysql2://root@127.0.0.1:10057/armg_test' -r armg -e > Schemafile

$ cat Schemafile
# Export Schema
create_table "geoms", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
  t.geometry "location", null: false
  t.string "name"
  t.index ["location"], name: "idx_location", length: 32, type: :spatial
  t.index ["name"], name: "idx_name", length: 10
end

$ ridgepole -c 'mysql2://root@127.0.0.1:10057/armg_test' -r armg,ridgepole-geo -a
Apply `Schemafile`
No change
```

## Related links

* [rgeo/rgeo: Geospatial data library for Ruby](https://github.com/rgeo/rgeo)
* [MySQL :: MySQL 5.7 Reference Manual :: 11.5.3 Supported Spatial Data Formats](https://dev.mysql.com/doc/refman/5.7/en/gis-data-formats.html)
