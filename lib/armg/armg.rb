# frozen_string_literal: true

module Armg
  @deserializer = Armg::WkbDeserializer.new
  @serializer = Armg::WkbSerializer.new

  class << self
    attr_reader :deserializer

    attr_writer :deserializer

    attr_reader :serializer

    attr_writer :serializer
  end
end
