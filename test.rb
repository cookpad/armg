#!/usr/bin/env ruby
require 'rgeo'
a = "0101000000000000000000F03F000000000000F03F"

factory = RGeo::Geographic.spherical_factory(:default_srid => 4326)
parser = RGeo::WKRep::WKBParser.new(nil, support_ewkb: true, default_srid: 4326)
point = parser.parse(a)
p point.srid

generator = RGeo::WKRep::WKTGenerator.new(tag_format: :ewkt) #, emit_ewkt_srid: true)
p generator.generate(point)
