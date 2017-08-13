class Armg::WkbDeserializer
  DEFAULT_OPTIONS = {
    support_ewkb: true,
  }

  def initialize(factory = nil, options = {})
    options = DEFAULT_OPTIONS.merge(options)
    @wkb_parser = RGeo::WKRep::WKBParser.new(factory, options)
  end

  def deserialize(wkb)
    wkb = wkb.b
    srid = wkb.slice!(0..3)
    wkb[4] = "\x20"
    wkb.insert(5, srid)
    @wkb_parser.parse(wkb)
  end
end
