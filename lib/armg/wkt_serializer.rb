class Armg::WktSerializer < Armg::WkbSerializer
  DEFAULT_OPTIONS = {
    support_ewkt: true
  }

  def initialize(factory = nil, options = {})
    super(options)
    options = DEFAULT_OPTIONS.merge(options)
    @wkt_parser = RGeo::WKRep::WKTParser.new(factory, options)
  end

  def serialize(wkt)
    obj = @wkt_parser.parse(wkt)
    super(obj)
  end
end
