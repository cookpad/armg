module Armg
  @deserializer = Armg::WkbDeserializer.new
  @serializer = Armg::WkbSerializer.new

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
