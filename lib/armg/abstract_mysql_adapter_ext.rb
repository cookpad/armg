# frozen_string_literal: true

module Armg
  module AbstractMysqlAdapterExt
    def indexes(*args, &block)
      is = super

      is.each do |i|
        i.lengths = nil if i.type == :spatial && i.respond_to?(:lengths=)
      end

      is
    end

    def type_map
      @type_map ||= super.tap { |m| m.register_type(/^geometry/i, Armg::MysqlGeometry.new) }
    end
  end
end
