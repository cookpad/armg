class Armg::MysqlGeometry < ActiveModel::Type::Value
  include ActiveModel::Type::Helpers::Mutable

  DEFAULT_WKB_PARSER = Armg::WkbParser.new
  DEFAULT_WKB_GENERATOR = Armg::WkbGenerator.new

  def type
    :geometry
  end

  def deserialize(value)
    if value.is_a?(::String)
      Armg.wkb_parser.parse(value)
    else
      value
    end
  end

  def serialize(value)
    if value.nil?
      nil
    else
      Armg.wkb_generator.generate(value)
    end
  end
end
