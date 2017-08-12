module Armg
  @wkb_parser = Armg::MysqlGeometry::DEFAULT_WKB_PARSER
  @wkb_generator = Armg::MysqlGeometry::DEFAULT_WKB_GENERATOR

  class << self
    def wkb_parser
      @wkb_parser
    end

    def wkb_parser=(parser)
      @wkb_parser = parser
    end

    def wkb_generator
      @wkb_generator
    end

    def wkb_generator=(generator)
      @wkb_generator = generator
    end
  end
end
