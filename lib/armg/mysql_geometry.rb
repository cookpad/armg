# frozen_string_literal: true

module Armg
  class MysqlGeometry < ActiveModel::Type::Value
    def type
      :geometry
    end

    def deserialize(value)
      if value.is_a?(::String)
        Armg.deserializer.deserialize(value)
      else
        value
      end
    end

    def serialize(value)
      if value.nil?
        nil
      else
        Armg.serializer.serialize(value)
      end
    end
  end
end
