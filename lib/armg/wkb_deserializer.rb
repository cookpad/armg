# frozen_string_literal: true

module Armg
  class WkbDeserializer
    DEFAULT_OPTIONS = {
      support_ewkb: true
    }.freeze

    def initialize(factory: nil, **options)
      options = DEFAULT_OPTIONS.merge(options)
      @wkb_parser = RGeo::WKRep::WKBParser.new(factory, options)
    end

    def deserialize(mysql_geometry)
      wkb = Armg::Utils.mysql_geometry_to_wkb(mysql_geometry)
      @wkb_parser.parse(wkb)
    end
  end
end
