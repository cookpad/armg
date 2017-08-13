require 'spec_helper'

RSpec.describe Armg do
  before :each do
    Armg.deserializer = Armg::WktDeserializer.new
    Armg.serializer = Armg::WktSerializer.new
  end

  context 'insert wkt' do
    specify do
      Geom.create!(id: 4, location: 'Point(-122.1 47.3)')
      geom = Geom.find(4)
      expect(geom.location).to eq 'Point (-122.1 47.3)'
    end
  end

  context 'update' do
    specify do
      geom = Geom.find(3)
      geom.location = 'Point(-122.1 147.3)'
      geom.save!
      geom = Geom.find(3)
      expect(geom.location).to eq 'Point (-122.1 147.3)'
    end
  end

  context 'select' do
    specify do
      { 1 => 'Point (1.0 1.0)',
        2 => 'LineString (0.0 0.0, 1.0 1.0, 2.0 2.0)',
        3 => 'Polygon ((0.0 0.0, 10.0 0.0, 10.0 10.0, 0.0 10.0, 0.0 0.0), (5.0 5.0, 7.0 5.0, 7.0 7.0, 5.0 7.0, 5.0 5.0))',
      }.each do |record_id, wkt|
        geom = Geom.find(record_id)
        expect(geom.location).to eq wkt
      end
    end
  end
end
