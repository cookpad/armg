class Armg::MysqlGeometry < ActiveModel::Type::Value
  DEFAULT_DESERIALIZER = Armg::WkbDeserializer.new
  DEFAULT_SERIALIZER = Armg::WkbSerializer.new

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
