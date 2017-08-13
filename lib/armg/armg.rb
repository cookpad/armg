module Armg
  class << self
    def deserializer
      @deserializer ||= Armg::WkbDeserializer.new
      @deserializer
    end

    def deserializer=(v)
      @deserializer = v
    end

    def serializer
      @serializer ||= Armg::WkbSerializer.new
      @serializer
    end

    def serializer=(v)
      @serializer = v
    end
  end
end
