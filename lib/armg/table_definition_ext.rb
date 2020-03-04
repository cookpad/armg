# frozen_string_literal: true

module Armg
  module TableDefinitionExt
    def geometry(*args, **options)
      args.each { |name| column(name, :geometry, options) }
    end
  end
end
