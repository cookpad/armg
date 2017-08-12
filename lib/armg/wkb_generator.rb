class Armg::WkbGenerator
  DEFAULT_OPTIONS = {
    type_format: :ewkb,
    little_endian: true,
  }

  def initialize(options = {})
    options = DEFAULT_OPTIONS.merge(options)
    @generator = RGeo::WKRep::WKBGenerator.new(options)
  end

  def generate(deserialized_value)
    srid = [deserialized_value.srid].pack('L<')
    srid + @generator.generate(deserialized_value)
  end
end
