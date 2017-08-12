require 'active_support/lazy_load_hooks'
require 'rgeo'
require 'armg/version'

ActiveSupport.on_load(:active_record) do
  require 'active_record/connection_adapters/abstract_mysql_adapter'
  require 'armg/wkb_generator'
  require 'armg/wkb_parser'
  require 'armg/abstract_mysql_adapter_ext'
  require 'armg/mysql_geometry'
  require 'armg/table_definition_ext'
  require 'armg/armg'

  ActiveRecord::ConnectionAdapters::AbstractMysqlAdapter::NATIVE_DATABASE_TYPES[:geometry] = { name: "geometry" }
  ActiveRecord::ConnectionAdapters::AbstractMysqlAdapter.prepend(Armg::AbstractMysqlAdapterExt)
  ActiveRecord::Type.register(:geometry, Armg::MysqlGeometry, adapter: :mysql2)
  ActiveRecord::ConnectionAdapters::MySQL::TableDefinition.prepend(Armg::TableDefinitionExt)
  ActiveRecord::ConnectionAdapters::MySQL::Table.prepend(Armg::TableDefinitionExt)
end
