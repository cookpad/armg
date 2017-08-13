class Armg::WkbSerializer
  DEFAULT_OPTIONS = {
    type_format: :ewkb,
    little_endian: true,
  }

  def initialize(**options)
    options = DEFAULT_OPTIONS.merge(options)
    @wkb_generator = RGeo::WKRep::WKBGenerator.new(options)
  end

  def serialize(obj)
    srid = Armg::Utils.pack_srid(obj.srid)
    srid + @wkb_generator.generate(obj)
  end
end
