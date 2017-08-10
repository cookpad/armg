module Armg::AbstractMysqlAdapterExt
  def initialize_type_map(m)
    super
    m.register_type %r(^geometry)i,  Armg::MysqlGeometry.new
  end
end
