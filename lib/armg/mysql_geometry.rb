class Armg::MysqlGeometry < ActiveModel::Type::Value
  include ActiveModel::Type::Helpers::Mutable

  def type
    :geometry
  end

  def deserialize(value)
    if value.is_a?(::String)
      srid = value[0..3].unpack('L<').first
      wkb_parser = RGeo::WKRep::WKBParser.new(nil, support_ewkb: true, default_srid: srid)
      wkb_parser.parse(value[4..-1])
    else
      value
    end
  end

  def serialize(value)
    if value.nil?
      nil
    else
      wkb_generator = RGeo::WKRep::WKBGenerator.new(type_format: :ewkb, little_endian: true)
      wkb = wkb_generator.generate(value)
      [value.srid].pack('L<') + wkb
    end
  end
end
