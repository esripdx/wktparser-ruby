require_relative "wktparser/version"
require_relative "wktparser/models"
require 'whittle'

module Wktparser
  class Whittler < Whittle::Parser

    rule(:space => /\s+/).skip!
    rule(:newline => /\n+/m).skip!
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
      # X, Y
      r[:double_tok, :double_tok].as do |x, y|
        Coordinate.new x, y
      end

      # Y, Y, Z
      r[:double_tok, :double_tok, :double_tok].as do |x, y, z|
        Coordinate.new x, y, z
      end

      # X, Y, Z, M
      r[:double_tok, :double_tok, :double_tok, :double_tok].as do |x, y, z, m|
        Coordinate.new x, y, z, m
      end
    end

    rule(:point) do |r|
      # POINT
      r[:point_text, :leftparen, :coordinate, :rightparen].as do |_, _, c, _|
        Point.new c
      end

      # POINT Z
      r[:point_text, :z, :leftparen, :coordinate, :rightparen].as do |_, _, _, c, _|
        Point.new c
      end

      # POINT M
      # Weird case, cause Coordinate doesn't know it should be m, not z...
      r[:point_text, :m, :leftparen, :coordinate, :rightparen].as do |_, _, _, c, _|
        newc = Coordinate.new c.x, c.y, nil, c.z
        Point.new newc
      end

      # POINT ZM
      r[:point_text, :zm, :leftparen, :coordinate, :rightparen].as do |_, _, _, c, _|
        Point.new c
      end

      # POINT EMPTY
      r[:point_text, :empty].as do |_, _|
        Point.new Coordinate.new nil, nil
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
end

