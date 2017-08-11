class Armg::MysqlGeometry < ActiveModel::Type::Value
  include ActiveModel::Type::Helpers::Mutable

  DEFAULT_WKB_PARSER_FACTORY = proc do |wkb|
    srid = wkb[0..3].unpack('L<').first
    RGeo::WKRep::WKBParser.new(nil, support_ewkb: true, default_srid: srid)
  end

  DEFAULT_WKB_GENERATOR_FACTORY = proc do |value|
    [ RGeo::WKRep::WKBGenerator.new(type_format: :ewkb, little_endian: true),
      [value.srid].pack('L<'),
    ]
  end

  def type
    :geometry
  end

  def deserialize(value)
    if value.is_a?(::String)
      wkb_parser = Armg.wkb_parser_factory.call(value)
      wkb_parser.parse(value[4..-1])
    else
      value
    end
  end

  def serialize(value)
    if value.nil?
      nil
    else
      wkb_generator, srid = Armg.wkb_generator_factory.call(value)
      wkb = wkb_generator.generate(value)
      srid + wkb
    end
  end
end
