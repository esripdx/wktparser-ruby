require "wktparser/version"
require "wktparser/symbols"
require "wktparser/terminals"
require "wktparser/productions"
require "wktparser/table"
require "wktparser/parser"

module Wktparser

  def self.encode stuff
    Wktparser.parse stuff
  end

  def self.decode stuff
    Wktparser.parse stuff
  end

end
