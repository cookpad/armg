class Armg::MysqlGeometry < ActiveModel::Type::Value
  include ActiveModel::Type::Helpers::Mutable

  def type
    :geometry
  end

  def deserialize(value)
    if value.is_a?(::String)
      # https://dev.mysql.com/doc/refman/5.6/en/gis-data-formats.html
      value.slice!(0, 5)
      value.unpack("L<E2")
    else
      value
    end
  end

  def serialize(value)
    if value.nil?
      nil
    else
      "\x00\x00\x00\x00\x01" + value.pack("L<E2")
    end
  end
end
