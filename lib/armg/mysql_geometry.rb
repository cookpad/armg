# frozen_string_literal: true

module Armg
  class MysqlGeometry < ActiveModel::Type::Value
    def type
      :geometry
    end

    def binary?
      true
    end

    def deserialize(value)
      case value
      when ::String
        Armg.deserializer.deserialize(value)
      when ActiveModel::Type::Binary::Data
        Armg.deserializer.deserialize(value.to_s)
      else
        value
      end
    end

    def serialize(value)
      if value.nil?
        nil
      else
        value = Armg.serializer.serialize(value)
        ActiveModel::Type::Binary::Data.new(value)
      end
    end
  end
end
