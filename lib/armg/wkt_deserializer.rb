class Armg::WktDeserializer < Armg::WkbDeserializer
  DEFAULT_OPTIONS = {
    tag_format: :ewkt,
    #emit_ewkt_srid: true,
  }

  def initialize(factory = nil, options = {})
    super(factory, options)
    options = DEFAULT_OPTIONS.merge(options)
    @generator = RGeo::WKRep::WKTGenerator.new(options)
  end

  def deserialize(wkb)
    obj = super(wkb)
    @generator.generate(obj)
  end
end
