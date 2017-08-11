# Armg

Add MySQL geometry type to Active Record.

[![Build Status](https://travis-ci.org/winebarrel/armg.svg?branch=master)](https://travis-ci.org/winebarrel/armg)

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

## Using custom WKB parser

```ruby
Armg.wkb_parser_factory = proc do |wkb|
  factory = RGeo::Geographic.spherical_factory(srid: 0)
  [ RGeo::WKRep::WKBParser.new(factory, support_ewkb: true),
    wkb[4..-1],
  ]
end

Geom.take
#=> #<Geom id: 1, location: #<RGeo::Geographic::SphericalPointImpl:0x... "POINT (-122.1 47.3)">>
```

## Using custom WKB generator

```ruby
class CustomGenerator
  def generate(value)
    if value.is_a?(String)
      value = RGeo::WKRep::WKTParser.new(nil, support_ewkt: true).parse(value)
    end

    RGeo::WKRep::WKBGenerator.new(type_format: :ewkb, little_endian: true).generate(value)
  end
end

Armg.wkb_generator_factory = proc do |_|
  [ CustomGenerator.new,
    "\x00\x00\x00\x00",
  ]
end

Geom.create!(id: 4, location: 'Point(-122.1 47.3)')
```
