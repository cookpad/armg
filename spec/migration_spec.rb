RSpec.describe Armg, skip_create_table: true do
  context 'create table' do
    specify do
      ActiveRecord::Migration.create_table :geoms, options: MysqlHelper::TABLE_OPTIONS do |t|
        t.geometry 'location', null: false
        t.string 'name'
        t.index ['location'], name: 'idx_location', type: :spatial
        t.index ['name'], name: 'idx_name', length: 10
      end

      schema = @mysql_helper.dump
      schema.sub!(', using: :btree', '') # for Active Record 5.0

      expect(schema).to match_ruby erbh(<<-ERB)
        create_table "geoms", force: :cascade, options: #{MysqlHelper::TABLE_OPTIONS.inspect} do |t|
          t.geometry "location", null: false
          t.string "name"
          t.index ["location"], name: "idx_location", type: :spatial <%= ActiveRecord.gem_version >= Gem::Version.new('5.2') ? ', length: 32' : '' %>
          t.index ["name"], name: "idx_name", length: <%= ActiveRecord.gem_version >= Gem::Version.new('5.2') ? '10' : '{ name: 10 }' %>
        end
      ERB
    end
  end

  context 'alter table' do
    before do
      ActiveRecord::Migration.create_table :geoms, options: MysqlHelper::TABLE_OPTIONS
    end

    specify do
      ActiveRecord::Migration.change_table :geoms do |t|
        t.geometry 'location', null: false
        t.index ['location'], name: 'idx_location', type: :spatial
      end

      expect(@mysql_helper.dump).to match_ruby erbh(<<~ERB)
        create_table "geoms", force: :cascade, options: #{MysqlHelper::TABLE_OPTIONS.inspect} do |t|
          t.geometry "location", null: false
          t.index ["location"], name: "idx_location", type: :spatial <%= ActiveRecord.gem_version >= Gem::Version.new('5.2') ? ', length: 32' : '' %>
        end
      ERB
    end

    specify do
      ActiveRecord::Migration.add_column :geoms, 'location', :geometry, null: false
      ActiveRecord::Migration.add_index :geoms, 'location', name: "idx_location", type: :spatial

      expect(@mysql_helper.dump).to match_ruby erbh(<<~ERB)
        create_table "geoms", force: :cascade, options: #{MysqlHelper::TABLE_OPTIONS.inspect} do |t|
          t.geometry "location", null: false
          t.index ["location"], name: "idx_location", type: :spatial <%= ActiveRecord.gem_version >= Gem::Version.new('5.2') ? ', length: 32' : '' %>
        end
      ERB
    end
  end
end
