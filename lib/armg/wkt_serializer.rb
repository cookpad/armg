# frozen_string_literal: true

module Armg
  class WktSerializer
    DEFAULT_WKB_GENERATOR_OPTIONS = {
      type_format: :ewkb,
      little_endian: true
    }.freeze

    DEFAULT_WKT_PARSER_OPTIONS = {
      support_ewkt: true
    }.freeze

    def initialize(factory: nil, wkb_generator_options: {}, wkt_parser_options: {})
      @wkb_generator = RGeo::WKRep::WKBGenerator.new(
        DEFAULT_WKB_GENERATOR_OPTIONS.merge(wkb_generator_options)
      )
      @wkt_parser = RGeo::WKRep::WKTParser.new(factory,
                                               DEFAULT_WKT_PARSER_OPTIONS.merge(wkt_parser_options))
    end

    def serialize(wkt)
      obj = @wkt_parser.parse(wkt)
      srid = Armg::Utils.pack_srid(obj.srid)
      srid + @wkb_generator.generate(obj)
    end
  end
end
