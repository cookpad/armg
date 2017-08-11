module Armg
  @wkb_parser_factory = Armg::MysqlGeometry::DEFAULT_WKB_PARSER_FACTORY
  @wkb_generator_factory = Armg::MysqlGeometry::DEFAULT_WKB_GENERATOR_FACTORY

  class << self
    def wkb_parser_factory
      @wkb_parser_factory
    end

    def wkb_parser_factory=(factory)
      @wkb_parser_factory = factory
    end

    def wkb_generator_factory
      @wkb_generator_factory
    end

    def wkb_generator_factory=(factory)
      @wkb_generator_factory = factory
    end
  end
end
