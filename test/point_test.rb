require_relative './test_helper.rb'

describe 'Primitives' do

  before do
  end

  describe Point do

    it 'must parse an empty point' do
      stuff = "point empty"
      p = Wktparser::Whittler.new
      results =  p.parse stuff
      puts results
      results.class.must_equal Point
      results.coordinate.x.must_be_nil
      results.coordinate.y.must_be_nil
      results.wont_be_nil
    end

    it 'must parse a Z empty point' do
      stuff = "point z empty"
      p = Wktparser::Whittler.new
      results =  p.parse stuff
      results.class.must_equal Point
      results.coordinate.x.must_be_nil
      results.coordinate.y.must_be_nil
      results.wont_be_nil
    end

    it 'must parse a M empty point' do
      stuff = "point m empty"
      p = Wktparser::Whittler.new
      results =  p.parse stuff
      results.class.must_equal Point
      results.coordinate.x.must_be_nil
      results.coordinate.y.must_be_nil
      results.wont_be_nil
    end

    it 'must parse a ZM empty point' do
      stuff = "point zm empty"
      p = Wktparser::Whittler.new
      results =  p.parse stuff
      results.class.must_equal Point
      results.coordinate.x.must_be_nil
      results.coordinate.y.must_be_nil
      results.wont_be_nil
    end

    it 'must parse a point' do
      stuff = 'point ( 10.05 10.28 )'
      p = Wktparser::Whittler.new
      results =  p.parse stuff
      results.class.must_equal Point
      results.coordinate.x.must_equal 10.05
      results.coordinate.y.must_equal 10.28
      results.wont_be_nil
    end

    it 'must parse a point with z-coordinate' do
      stuff = 'point z( 10.05 10.28 2.51 )'
      p = Wktparser::Whittler.new
      results =  p.parse stuff
      results.class.must_equal Point
      results.coordinate.x.must_equal 10.05
      results.coordinate.y.must_equal 10.28
      results.coordinate.z.must_equal 2.51
      results.coordinate.m.must_be_nil
      results.wont_be_nil
    end

    it 'must parse a point with meaasure' do
      stuff = 'point m( 10.05 10.28 4.72 )'
      p = Wktparser::Whittler.new
      results =  p.parse stuff
      results.class.must_equal Point
      results.coordinate.x.must_equal 10.05
      results.coordinate.y.must_equal 10.28
      results.coordinate.m.must_equal 4.72
      results.coordinate.z.must_be_nil
      results.wont_be_nil
    end

    it 'must parse a point with z-coordinate and measure' do
      stuff = 'point zm(10.05 10.28 2.51 4.72 )'
      p = Wktparser::Whittler.new
      results =  p.parse stuff
      results.class.must_equal Point
      results.coordinate.x.must_equal 10.05
      results.coordinate.y.must_equal 10.28
      results.coordinate.m.must_equal 4.72
      results.coordinate.z.must_equal 2.51
      results.wont_be_nil
    end

    it 'must output geojson' do
      stuff = 'point ( 10.05 10.28 )'
      p = Wktparser::Whittler.new
      results =  p.parse stuff
      results.class.must_equal Point
      results.coordinate.x.must_equal 10.05
      results.coordinate.y.must_equal 10.28
      geojson = results.to_geojson
      geojson.must_equal %{{"type":"Point","coordinates":[10.05,10.28]}}
      results.wont_be_nil
    end

  end

end

__END__
ST_Point

'point empty'

Empty point

ST_Point

'point z empty'

Empty point with z-coordinate

ST_Point

'point m empty'

Empty point with measure

ST_Point

'point zm empty'

Empty point with z-coordinate and measure

ST_Point

'point ( 10.05 10.28 )'

Point

ST_Point

'point z( 10.05 10.28 2.51 )'

Point with z-coordinate

ST_Point

'point m( 10.05 10.28 4.72 )'

Point with measure

ST_Point

'point zm(10.05 10.28 2.51 4.72 )'

#test = Wktparser::Whittler.new
#puts test.parse("POINT(45.521642 -122.677481)")
#puts test.parse("LINESTRING (30 10, 10 30, 40 40)")
#puts test.parse("MULTILINESTRING ((10 10, 20 20, 10 40),(40 40, 30 30, 40 20, 30 10))

