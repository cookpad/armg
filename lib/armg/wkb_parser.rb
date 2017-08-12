class Armg::WkbParser
  DEFAULT_OPTIONS = {
    support_ewkb: true,
  }

  def initialize(factory = nil, options = {})
    options = DEFAULT_OPTIONS.merge(options)
    @parser = RGeo::WKRep::WKBParser.new(factory, options)
  end

  def parse(wkb)
    wkb = wkb.b
    srid = wkb.slice!(0..3)
    wkb[4] = "\x20"
    wkb.insert(5, *srid)
    @parser.parse(wkb)
  end
end
