module Armg
  @deserializer = Armg::MysqlGeometry::DEFAULT_DESERIALIZER
  @serializer = Armg::MysqlGeometry::DEFAULT_SERIALIZER

  class << self
    def deserializer
      @deserializer
    end

    def deserializer=(v)
      @deserializer = v
    end

    def serializer
      @serializer
    end

    def serializer=(v)
      @serializer = v
    end
  end
end
