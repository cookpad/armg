module Armg::AbstractMysqlAdapterExt
  def initialize_type_map(m)
    super
    m.register_type %r(^geometry)i,  Armg::MysqlGeometry.new
  end

  def indexes(*args, &block)
    super.tap do |is|
      is.each do |i|
        i.lengths = nil if i.type = :spatial
      end
    end
  end
end
