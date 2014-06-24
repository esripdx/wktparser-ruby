require_relative "wktparser/version"
require 'whittle'
require 'ostruct'

class Wktwhittler < Whittle::Parser

  rule(:space => /\s+/).skip!
  rule(:leftparen => /\(/)
  rule(:rightparen => /\)/)
  rule(:double_tok => /\-?[0-9]+(\.[0-9]+)?/).as { |num| num.to_f }
  rule(:point_text => /POINT/) % :left
  rule(:linestring_text => /LINESTRING/) % :left
  rule(:polygon_text => /POLYGON/) % :left
  rule(:multipoint_text => /MULTIPOINT/) % :left
  rule(:multilinestring_text => /MULTILINESTRING/) % :left
  rule(:multipolygon_text => /MULTIPOLYGON/) % :left
  rule(:geometrycollection_text => /GEOMETRYCOLLECTION/) % :left
  rule(:comma => /,/)
  rule(:empty => /EMPTY/)
  rule(:m => /M/)
  rule(:z => /Z/)
  rule(:zm => /ZM/)
  #rule(:<<EOF>>                      # return 'EOF'
  #rule(:invalid => /\./)                            # return "INVALID"

  rule(:coordinate) do |r|
    r[:double_tok, :comma, :double_tok].as do |x, _, y|
      o = OpenStruct.new
      o.type = "Coordinate"
      o.x = x
      o.y = y
      o
    end
  end

  rule(:point) do |r|
    r[:point_text, :leftparen, :coordinate, :rightparen].as do |_, _, c, _|
      o = OpenStruct.new
      o.type = "Point"
      o.coordinates = c
      o
    end
  end

  rule(:expr) do |r|
    r[:point]
    # r[:linestring]
    # r[:polygon]
    # r[:multipoint]
    # r[:multilinestring]
    # r[:multipolygon]
    # r[:geometrycollection]
  end

  start(:expr)
end

test = Wktwhittler.new
result = test.parse("POINT(45.521642, -122.677481)")
puts result.inspect

