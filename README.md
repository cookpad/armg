# Armg

Add MySQL geometry type to Active Record.

[![Gem Version](https://badge.fury.io/rb/armg.svg)](https://badge.fury.io/rb/armg)
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
class CustomParser
  def initialize
    factory = RGeo::Geographic.spherical_factory(srid: 0)
    @parser = RGeo::WKRep::WKBParser.new(factory, support_ewkb: true)
  end

  def parse(wkb)
    wkb_without_srid = wkb.bytes[4..-1].pack('c*')
    @parser.parse(wkb_without_srid)
  end
end

Armg.wkb_parser = CustomParser.new

Geom.take
#=> #<Geom id: 1, location: #<RGeo::Geographic::SphericalPointImpl:0x... "POINT (-122.1 47.3)">>
```

## Using custom WKB generator

```ruby
class CustomGenerator
  def initialize
    @wkt_parser = RGeo::WKRep::WKTParser.new(nil, support_ewkt: true)
    @generator = RGeo::WKRep::WKBGenerator.new(type_format: :ewkb, little_endian: true)
  end

  def generate(value)
    if value.is_a?(String)
      value = @wkt_parser.parse(value)
    end

    srid = "\x00\x00\x00\x00"
    srid + @generator.generate(value)
  end
end

Armg.wkb_generator = CustomGenerator.new

Geom.create!(id: 4, location: 'Point(-122.1 47.3)')
```
