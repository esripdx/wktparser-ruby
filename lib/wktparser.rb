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
    rule(:point_text => /POINT/i) % :left
    rule(:linestring_text => /LINESTRING/i) % :left
    rule(:polygon_text => /POLYGON/i) % :left
    rule(:multipoint_text => /MULTIPOINT/i) % :left
    rule(:multilinestring_text => /MULTILINESTRING/i) % :left
    rule(:multipolygon_text => /MULTIPOLYGON/i) % :left
    rule(:geometrycollection_text => /GEOMETRYCOLLECTION/i) % :left
    rule(:comma => /,/)
    rule(:empty => /EMPTY/i)
    rule(:m => /M/i)
    rule(:z => /Z/i)
    rule(:zm => /ZM/i)

    # COORDINATE ------------------------------------------------------------
    rule(:coordinate) do |r|
      # X, Y
      r[:double_tok, :double_tok].as do |x, y|
        Coordinate.new x, y
      end

      # X, Y, Z
      # TODO could be M not Z!
      r[:double_tok, :double_tok, :double_tok].as do |x, y, z|
        Coordinate.new x, y, z
      end

      # X, Y, Z, M
      r[:double_tok, :double_tok, :double_tok, :double_tok].as do |x, y, z, m|
        Coordinate.new x, y, z, m
      end
    end

    # POINT ------------------------------------------------------------
    rule(:point) do |r|

      # POINT EMPTY
      r[:point_text, :empty].as do |_, _|
        Point.new Coordinate.new nil, nil
      end

      # POINT
      r[:point_text, :leftparen, :coordinate, :rightparen].as do |_, _, c, _|
        Point.new c
      end

      # POINT Z
      r[:point_text, :z, :leftparen, :coordinate, :rightparen].as do |_, _, _, c, _|
        Point.new c
      end

      # POINT M
      r[:point_text, :m, :leftparen, :coordinate, :rightparen].as do |_, _, _, c, _|
        c.m = c.z
        c.z = nil
        Point.new c
      end

      # POINT ZM
      r[:point_text, :zm, :leftparen, :coordinate, :rightparen].as do |_, _, _, c, _|
        Point.new c
      end

    end

    # POINT LIST ------------------------------------------------------------
    rule(:point_list) do |r|
      # POINT LIST
      r[:point_list, :comma, :coordinate].as do |pl, _, c|
        pl.add_point c
        pl
      end

      # COORDINATE
      r[:coordinate].as do |c|
        Pointlist.new [c]
      end
    end

    # LINESTRING ------------------------------------------------------------
    rule(:linestring) do |r|
      # LINESTRING
      r[:linestring_text, :leftparen, :point_list, :rightparen].as do |_, _, l, _|
        Linestring.new l
      end

      # LINESTRING Z
      r[:linestring_text, :z, :leftparen, :point_list, :rightparen].as do |_, _, _, l, _|
        Linestring.new l
      end

      # LINESTRING M
      # BLERG TODO make this better
      r[:linestring_text, :m, :leftparen, :point_list, :rightparen].as do |_, _, _, l, _|
        l.coordinates.map{ |c| c.m = c.z; c.z = nil }
        Linestring.new l
      end

      # LINESTRING ZM
      r[:linestring_text, :zm, :leftparen, :point_list, :rightparen].as do |_, _, _, l, _|
        Linestring.new l
      end

      # LINESTRING EMPTY
      r[:linestring_text, :empty].as do |_, _|
        Linestring.new Pointlist.new nil
      end
    end

    rule(:expr) do |r|
      r[:point]
      r[:linestring]
      # r[:polygon]
      # r[:multipoint]
      # r[:multilinestring]
      # r[:multipolygon]
      # r[:geometrycollection]
    end

    start(:expr)
  end
end

