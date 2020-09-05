# frozen_string_literal: true

module Armg
  module AbstractMysqlAdapterExt
    def initialize_type_map(m = type_map)
      super
      m.register_type(/^geometry/i, Armg::MysqlGeometry.new)
    end

    def indexes(*args, &block)
      is = super

      is.each do |i|
        i.lengths = nil if i.type == :spatial && i.respond_to?(:lengths=)
        i.instance_variable_set(:@lengths, nil) if i.type == :spatial && i.instance_variable_defined?(:@lengths)
      end

      is
    end
  end
end
