# frozen_string_literal: true

module Armg
  class WktDeserializer
    DEFAULT_WKB_PARSER_OPTIONS = {
      support_ewkb: true
    }.freeze

    DEFAULT_WKT_GENERATOR_OPTIONS = {
      tag_format: :ewkt
      # emit_ewkt_srid: true,
    }.freeze

    def initialize(factory: nil, wkb_parser_options: {}, wkt_generator_options: {})
      @wkb_parser = RGeo::WKRep::WKBParser.new(
        factory,
        DEFAULT_WKB_PARSER_OPTIONS.merge(wkb_parser_options)
      )
      @wkt_generator = RGeo::WKRep::WKTGenerator.new(
        DEFAULT_WKT_GENERATOR_OPTIONS.merge(wkt_generator_options)
      )
    end

    def deserialize(mysql_geometry)
      wkb = Armg::Utils.mysql_geometry_to_wkb(mysql_geometry)
      obj = @wkb_parser.parse(wkb)
      @wkt_generator.generate(obj)
    end
  end
end
