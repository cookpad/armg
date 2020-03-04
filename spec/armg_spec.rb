# frozen_string_literal: true

RSpec.describe Armg do
  let(:wkt_parser) { RGeo::WKRep::WKTParser.new(nil, support_ewkt: true) }

  context 'insert' do
    specify do
      point = wkt_parser.parse('SRID=4326;Point(-122.1 47.3)')
      Geom.create!(id: 4, location: point)
      geom = Geom.find(4)
      expect(geom.location.srid).to eq 4326
      expect(geom.location.to_s).to eq 'POINT (-122.1 47.3)'
      rs = ActiveRecord::Base.connection.execute('SELECT LEFT(HEX(location), 8), AsText(location) FROM geoms WHERE id = 4')
      expect(rs.to_a).to eq([['E6100000', 'POINT(-122.1 47.3)']])
    end
  end

  context 'delete' do
    specify do
      geom = Geom.find(2)
      geom.destroy!
      expect(Geom.all.map(&:id)).to match_array [1, 3]
    end
  end

  context 'update' do
    specify do
      geom = Geom.find(3)
      point = wkt_parser.parse('SRID=14326;Point(-122.1 147.3)')
      geom.location = point
      geom.save!
      geom = Geom.find(3)
      expect(geom.location.srid).to eq 14_326
      expect(geom.location.to_s).to eq 'POINT (-122.1 147.3)'
      rs = ActiveRecord::Base.connection.execute('SELECT LEFT(HEX(location), 8), AsText(location) FROM geoms WHERE id = 3')
      expect(rs.to_a).to eq([['F6370000', 'POINT(-122.1 147.3)']])
    end
  end

  context 'select' do
    specify do
      {
        1 => ['POINT (1.0 1.0)', 1245],
        2 => ['LINESTRING (0.0 0.0, 1.0 1.0, 2.0 2.0)', 0],
        3 => ['POLYGON ((0.0 0.0, 10.0 0.0, 10.0 10.0, 0.0 10.0, 0.0 0.0), (5.0 5.0, 7.0 5.0, 7.0 7.0, 5.0 7.0, 5.0 5.0))', 5678]
      }.each do |record_id, (wkt, srid)|
        geom = Geom.find(record_id)
        expect(geom.location.srid).to eq srid
        expect(geom.location.to_s).to eq wkt
      end
    end
  end

  context 'passing custom deserializer' do
    class CustomDeserializer
      def initialize
        factory = RGeo::Geographic.spherical_factory(srid: 0)
        @wkb_parser = RGeo::WKRep::WKBParser.new(factory, support_ewkb: true)
      end

      def deserialize(wkb)
        wkb_without_srid = wkb.b.slice(4..-1)
        @wkb_parser.parse(wkb_without_srid)
      end
    end

    specify do
      Armg.deserializer = CustomDeserializer.new

      { 1 => ['POINT (1.0 1.0)', 0, RGeo::Geographic::SphericalPointImpl],
        2 => ['LINESTRING (0.0 0.0, 1.0 1.0, 2.0 2.0)', 0, RGeo::Geographic::SphericalLineStringImpl],
        3 => ['POLYGON ((0.0 0.0, 10.0 0.0, 10.0 10.0, 0.0 10.0, 0.0 0.0), (5.0 5.0, 7.0 5.0, 7.0 7.0, 5.0 7.0, 5.0 5.0))', 0, RGeo::Geographic::SphericalPolygonImpl] }.each do |record_id, (wkt, srid, klass)|
        geom = Geom.find(record_id)
        expect(geom.location).to be_a klass
        expect(geom.location.srid).to eq srid
        expect(geom.location.to_s).to eq wkt
      end
    end
  end

  context 'passing custom serializer' do
    class CustomSerializer
      def initialize
        @wkt_parser = RGeo::WKRep::WKTParser.new(nil, support_ewkt: true)
        @wkb_generator = RGeo::WKRep::WKBGenerator.new(type_format: :ewkb, little_endian: true)
      end

      def serialize(value)
        value = @wkt_parser.parse(value) if value.is_a?(String)

        srid = "\x00\x00\x00\x00"
        srid + @wkb_generator.generate(value)
      end
    end

    specify do
      Armg.serializer = CustomSerializer.new
      Geom.create!(id: 4, location: 'Point(-122.1 47.3)')
      geom = Geom.find(4)
      expect(geom.location.srid).to eq 0
      expect(geom.location.to_s).to eq 'POINT (-122.1 47.3)'
    end
  end
end
