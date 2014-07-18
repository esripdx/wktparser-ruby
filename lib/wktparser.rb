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
        PointArray.new([Coordinate.new(x, y)])
      end

      # X, Y, Z
      r[:double_tok, :double_tok, :double_tok].as do |x, y, z|
        PointArray.new([Coordinate.new(x, y, z)])
      end

      # X, Y, Z, M
      r[:double_tok, :double_tok, :double_tok, :double_tok].as do |x, y, z, m|
        PointArray.new([Coordinate.new(x, y, z, m)])
      end
    end

    # PTARRAY ------------------------------------------------------------
    rule(:ptarray) do |r|
      # PTARRAY
      r[:ptarray, :comma, :coordinate].as do |pt, _, coord|
        pt.add_point coord
        pt
      end

      # COORDINATE
      r[:coordinate].as do |coord|
        coord
      end
    end

    # RING LIST ------------------------------------------------------------
    rule(:ring_list) do |r|
      # RING LIST
      r[:ring_list, :comma, :ring].as do |rl, _, r|
        rl.add_ring r
        rl
      end

      # RING
      r[:ring].as do |r|
        Ringlist.new [r]
      end
    end

    # RING ------------------------------------------------------------
    rule(:ring) do |r|
      # RING
      r[:leftparen, :ptarray, :rightparen].as do |_, c, _|
        Ring.new c
      end
    end

    # POINT ------------------------------------------------------------
    rule(:point) do |r|

      # point empty
      r[:point_text, :empty].as do |_, _|
        Point.new Coordinate.new nil, nil
      end

      # point z empty
      r[:point_text,:z, :empty].as do |_, _|
        Point.new Coordinate.new nil, nil
      end

      # point m empty
      r[:point_text, :m, :empty].as do |_, _|
        Point.new Coordinate.new nil, nil
      end

      # point zm empty
      r[:point_text,:zm, :empty].as do |_, _|
        Point.new Coordinate.new nil, nil
      end

      # POINT
      r[:point_text, :leftparen, :ptarray, :rightparen].as do |_, _, c, _|
        Point.new c.coordinates[0]
      end

      # POINT Z
      r[:point_text, :z, :leftparen, :ptarray, :rightparen].as do |_, _, _, c, _|
        Point.new c.coordinates[0]
      end

      # POINT M
      r[:point_text, :m, :leftparen, :ptarray, :rightparen].as do |_, _, _, c, _|
        c.coordinates[0].m = c.coordinates[0].z
        c.coordinates[0].z = nil
        Point.new c.coordinates[0]
      end

      # POINT ZM
      r[:point_text, :zm, :leftparen, :ptarray, :rightparen].as do |_, _, _, c, _|
        Point.new c.coordinates[0]
      end

    end

    # POINT UNTAGGED - what is this? ------------------------------------------------------------
    rule(:point_untagged) do |r|

      r[:coordinate].as do |c|
        c
      end

      r[:leftparen, :coordinate, :rightparen].as do |c|
        c
      end

    end

    # LINESTRING ------------------------------------------------------------
    rule(:linestring) do |r|
      # LINESTRING
      r[:linestring_text, :leftparen, :ptarray, :rightparen].as do |_, _, l, _|
        Linestring.new l.coordinates
      end

      # LINESTRING Z
      r[:linestring_text, :z, :leftparen, :ptarray, :rightparen].as do |_, _, _, l, _|
        Linestring.new l.coordinates
      end

      # LINESTRING M
      # BLERG TODO make this better
      r[:linestring_text, :m, :leftparen, :ptarray, :rightparen].as do |_, _, _, l, _|
        puts "LS coords m #{l.coordinates}"
        l.coordinates.map{ |c| c.m = c.z; c.z = nil }
        Linestring.new l.coordinates
      end

      # LINESTRING ZM
      r[:linestring_text, :zm, :leftparen, :ptarray, :rightparen].as do |_, _, _, l, _|
        Linestring.new l.coordinates
      end

      # LINESTRING EMPTY
      r[:linestring_text, :empty].as do |_, _|
        Linestring.new PointArray.new nil
      end

      # LINESTRING Z EMPTY
      r[:linestring_text, :z, :empty].as do |_, _|
        Linestring.new PointArray.new nil
      end

      # LINESTRING M EMPTY
      r[:linestring_text, :m, :empty].as do |_, _|
        Linestring.new PointArray.new nil
      end

      # LINESTRING ZM EMPTY
      r[:linestring_text, :zm, :empty].as do |_, _|
        Linestring.new PointArray.new nil
      end
    end

    # POLYGON ------------------------------------------------------------
    rule(:polygon) do |r|
      # POLYGON
      r[:polygon_text, :leftparen, :ring_list, :rightparen].as do |_, _, rl, _|
        Polygon.new rl
      end

      # POLYGON Z
      r[:polygon_text, :z, :leftparen, :ring_list, :rightparen].as do |_, _, _, rl, _|
        Polygon.new rl
      end

      # POLYGON M
      # BLERG TODO make this better
      r[:polygon_text, :m, :leftparen, :ring_list, :rightparen].as do |_, _, _, rl, _|
        # FIXME l.coordinates.map{ |c| c.m = c.z; c.z = nil }
        Polygon.new rl
      end

      # POLYGON ZM
      r[:polygon_text, :zm, :leftparen, :ring_list, :rightparen].as do |_, _, _, rl, _|
        Polygon.new rl
      end

      # POLYGON EMPTY
      r[:polygon_text, :empty].as do |_, _|
        Polygon.new Ringlist.new nil
      end

      # POLYGON Z EMPTY
      r[:polygon_text, :z, :empty].as do |_, _|
        Polygon.new Ringlist.new nil
      end

      # POLYGON M EMPTY
      r[:polygon_text, :m, :empty].as do |_, _|
        Polygon.new Ringlist.new nil
      end

      # POLYGON ZM EMPTY
      r[:polygon_text, :zm, :empty].as do |_, _|
        Polygon.new Ringlist.new nil
      end
    end

    rule(:expr) do |r|
      r[:point]
      r[:linestring]
      r[:polygon]
      # r[:multipoint]
      # r[:multilinestring]
      # r[:multipolygon]
      # r[:geometrycollection]
    end

    start(:expr)
  end
end

