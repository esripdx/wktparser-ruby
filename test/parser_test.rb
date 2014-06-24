require_relative './test_helper.rb'

describe Wktparser do

  before do
  end

  describe 'parser' do

    it 'must parse all examples' do

      p = Wktparser::Whittler.new
      root = File.expand_path File.join File.dirname(__FILE__), '..'
      Dir.glob("#{root}/examples/*.wkt").each do |file|
        puts file
        stuff = File.read file
        puts p.parse stuff
      end

    end

  end

end


#test = Wktparser::Whittler.new
#puts test.parse("POINT(45.521642 -122.677481)")
#puts test.parse("LINESTRING (30 10, 10 30, 40 40)")
#puts test.parse("MULTILINESTRING ((10 10, 20 20, 10 40),(40 40, 30 30, 40 20, 30 10))

