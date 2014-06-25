require_relative './test_helper.rb'

describe 'Primitives' do

  before do
  end

  describe Linestring do

    it 'must parse an empty linestring' do
      stuff = "linestring empty"
      p = Wktparser::Whittler.new
      results =  p.parse stuff
      results.class.must_equal Linestring
      results.coordinates.must_be_nil
      results.wont_be_nil
    end

    it 'must parse a Z empty linestring' do
      stuff = "linestring z empty"
      p = Wktparser::Whittler.new
      results =  p.parse stuff
      results.class.must_equal Linestring
      results.coordinates.must_be_nil
      results.wont_be_nil
    end

    it 'must parse a M empty linestring' do
      stuff = "linestring m empty"
      p = Wktparser::Whittler.new
      results =  p.parse stuff
      results.class.must_equal Linestring
      results.coordinates.must_be_nil
      results.wont_be_nil
    end

    it 'must parse a ZM empty linestring' do
      stuff = "linestring zm empty"
      p = Wktparser::Whittler.new
      results =  p.parse stuff
      results.coordinates.must_be_nil
      results.class.must_equal Linestring
      results.wont_be_nil
    end

    it 'must parse a linestring' do
      stuff = 'linestring (10.05 10.28 , 20.95 20.89 )'
      p = Wktparser::Whittler.new
      results =  p.parse stuff
      results.class.must_equal Linestring
      results.coordinates[0].x.must_equal 10.05
      results.coordinates[1].x.must_equal 20.95
      results.coordinates[0].y.must_equal 10.28
      results.coordinates[1].y.must_equal 20.89
      results.wont_be_nil
    end

    it 'must parse a linestring with z-coordinate' do
      stuff = 'linestring z(10.05 10.28 3.09, 20.95 31.98 4.72, 21.98 29.80 3.51 )'
      p = Wktparser::Whittler.new
      results =  p.parse stuff
      results.class.must_equal Linestring
      results.coordinates[0].x.must_equal 10.05
      results.coordinates[0].y.must_equal 10.28
      results.coordinates[0].z.must_equal 3.09
      results.coordinates[0].m.must_be_nil
      results.coordinates[1].x.must_equal 20.95
      results.coordinates[1].y.must_equal 31.98
      results.coordinates[1].z.must_equal 4.72
      results.coordinates[1].m.must_be_nil
      results.coordinates[2].x.must_equal 21.98
      results.coordinates[2].y.must_equal 29.80
      results.coordinates[2].z.must_equal 3.51
      results.coordinates[2].m.must_be_nil
      results.wont_be_nil
    end

    it 'must parse a linestring with measure' do
      stuff = 'linestring m(10.05 10.28 5.84, 20.95 31.98 9.01, 21.98 29.80 12.84 )'
      p = Wktparser::Whittler.new
      results =  p.parse stuff
      results.class.must_equal Linestring
      results.coordinates[0].x.must_equal 10.05
      results.coordinates[0].y.must_equal 10.28
      results.coordinates[0].m.must_equal 5.84
      results.coordinates[0].z.must_be_nil
      results.coordinates[1].x.must_equal 20.95
      results.coordinates[1].y.must_equal 31.98
      results.coordinates[1].m.must_equal 9.01
      results.coordinates[1].z.must_be_nil
      results.coordinates[2].x.must_equal 21.98
      results.coordinates[2].y.must_equal 29.80
      results.coordinates[2].m.must_equal 12.84
      results.coordinates[2].z.must_be_nil
      results.wont_be_nil
    end

    it 'must parse a linestring with z-coordinate and measure' do
      stuff = 'linestring zm(10.05 10.28 3.09 5.84, 20.95 31.98 4.72 9.01, 21.98 29.80 3.51 12.84)'
      p = Wktparser::Whittler.new
      results =  p.parse stuff
      results.class.must_equal Linestring
      results.coordinates[0].x.must_equal 10.05
      results.coordinates[0].y.must_equal 10.28
      results.coordinates[0].m.must_equal 5.84
      results.coordinates[0].z.must_equal 3.09
      results.coordinates[1].x.must_equal 20.95
      results.coordinates[1].y.must_equal 31.98
      results.coordinates[1].m.must_equal 9.01
      results.coordinates[1].z.must_equal 4.72
      results.coordinates[2].x.must_equal 21.98
      results.coordinates[2].y.must_equal 29.80
      results.coordinates[2].m.must_equal 12.84
      results.coordinates[2].z.must_equal 3.51
      results.wont_be_nil
    end

    it 'must output geojson' do
      stuff = 'linestring (10.05 10.28 , 20.95 20.89 )'
      p = Wktparser::Whittler.new
      results =  p.parse stuff
      results.class.must_equal Linestring
      geojson = results.to_geojson
      geojson.must_equal %{{"type":"LineString","coordinates":[[10.05,10.28],[20.95,20.89]]}}
      results.wont_be_nil
    end

  end

end

__END__

ST_LineString

'linestring empty'

Empty linestring

ST_LineString

'linestring z empty'

Empty linestring with z-coordinates

ST_LineString

'linestring m empty'

Empty linestring with measures

ST_LineString

'linestring zm empty'

Empty linestring with z-coordinates and measures

ST_LineString

'linestring (10.05 10.28 , 20.95 20.89 )'

Linestring

ST_LineString

'linestring z(10.05 10.28 3.09, 20.95 31.98 4.72, 21.98 29.80 3.51 )'

Linestring with z-coordinates

ST_LineString

'linestring m(10.05 10.28 5.84, 20.95 31.98 9.01, 21.98 29.80 12.84 )'

Linestring with measures

ST_LineString

'linestring zm(10.05 10.28 3.09 5.84, 20.95 31.98 4.72 9.01, 21.98 29.80 3.51 12.84)'

Linestring with z-coordinates and measures
