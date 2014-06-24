require_relative './test_helper.rb'

describe Wktparser do

  before do
    @stuff = "POINT 1 1"
  end

  describe 'parser' do

    it 'must parse stuff' do
      p = Wktparser.encode @stuff
      puts p.inspect
    end
  end

end
