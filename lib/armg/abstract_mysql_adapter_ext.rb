module Armg::AbstractMysqlAdapterExt
  def initialize_type_map(m = type_map)
    super
    m.register_type %r(^geometry)i, Armg::MysqlGeometry.new
  end

  def indexes(*args, &block)
    is = super

    is.each do |i|
      if i.type == :spatial && i.respond_to?(:lengths=)
        i.lengths = nil
      end
    end

    is
  end
end
