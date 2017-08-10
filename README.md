# Armg

Add MySQL geometry type to Active Record.

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

ActiveRecord::Base.establish_connection(adapter: 'mysql2', database: 'my_app');

ActiveRecord::Migration.create_table :geoms do |t|
  t.geometry 'location'
end

class Geom < ActiveRecord::Base; end

Geom.create!(location: [1, 1.0, 1.0])
#=> #<Geom id: 1 location: [1, 1.0, 1.0]>

# [1,   # WKB type
#  1.0, # X coordinate
#  1.0] # Y coordinate
# WKB type:
#   1: Point
#   2: LineString
#   3: Polygon
#   4: MultiPoint
#   5: MultiLineString
#   6: MultiPolygon
#   7:GeometryCollection.
# see https://dev.mysql.com/doc/refman/5.6/en/gis-data-formats.html

Geom.first
#=> #<Geom id: 1, location: [1, 1.0, 1.0]>
```
