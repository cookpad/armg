RSpec.describe Armg::Utils do
  describe '.mysql_geometry_to_wkb' do
    specify do
      mysql_geometry = "\xFF\xFF\xFF\xFF\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\xF0\x3F\x00\x00\x00\x00\x00\x00\xF0\xBF"
      wkb = Armg::Utils.mysql_geometry_to_wkb(mysql_geometry)
      expect(wkb).to eq "\x01\x01\x00\x00\x20\xFF\xFF\xFF\xFF\x00\x00\x00\x00\x00\x00\xF0\x3F\x00\x00\x00\x00\x00\x00\xF0\xBF".b
    end
  end

  describe '.pack_srid' do
    specify do
      packed = Armg::Utils.pack_srid(4321)
      expect(packed).to eq "\xE1\x10\x00\x00".b
    end
  end
end
