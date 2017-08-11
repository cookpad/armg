RSpec.describe Armg, skip_create_table: true do
  context 'create table' do
    specify do
      ActiveRecord::Migration.create_table :geoms, options: 'ENGINE=MyISAM' do |t|
        t.geometry 'location', null: false
        t.index ['location'], name: 'idx_location', type: :spatial
      end

      expect(@mysql_helper.dump).to match_fuzzy <<-RUBY
        create_table "geoms", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1" do |t|
          t.geometry "location", null: false
          t.index ["location"], name: "idx_location", type: :spatial
        end
      RUBY
    end
  end

  context 'alter table' do
    before do
      ActiveRecord::Migration.create_table :geoms, options: 'ENGINE=MyISAM'
    end

    specify do
      ActiveRecord::Migration.change_table :geoms do |t|
        t.geometry 'location', null: false
        t.index ['location'], name: 'idx_location', type: :spatial
      end

      expect(@mysql_helper.dump).to match_fuzzy <<-RUBY
        create_table "geoms", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1" do |t|
          t.geometry "location", null: false
          t.index ["location"], name: "idx_location", type: :spatial
        end
      RUBY
    end

    specify do
      ActiveRecord::Migration.add_column :geoms, 'location', :geometry, null: false
      ActiveRecord::Migration.add_index :geoms, 'location', name: "idx_location", type: :spatial

      expect(@mysql_helper.dump).to match_fuzzy <<-RUBY
        create_table "geoms", force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=latin1" do |t|
          t.geometry "location", null: false
          t.index ["location"], name: "idx_location", type: :spatial
        end
      RUBY
    end
  end
end
