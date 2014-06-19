require "wktparser/version"
require "wktparser/parser"

module Wktparser

  def self.encode stuff
    Wktparser.parse stuff
  end

  def self.decode stuff
    Wktparser.parse stuff
  end

end
