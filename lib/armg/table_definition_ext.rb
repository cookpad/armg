module Armg::TableDefinitionExt
  def geometry(*args, **options)
    args.each { |name| column(name, :geometry, options) }
  end
end
