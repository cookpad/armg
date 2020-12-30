# frozen_string_literal: true

module Armg
  @deserializer = Armg::WkbDeserializer.new
  @serializer = Armg::WkbSerializer.new

  class << self
    attr_accessor :deserializer, :serializer
  end
end
