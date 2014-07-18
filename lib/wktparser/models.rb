require 'json'

class Primitive
  attr_accessor :type, :properties, :coordinates

end

class Geojsonable < Primitive

  def to_s

    description = "#<#{self.type} => "
    description += self.coordinates.to_s

    # self.instance_variables.sort.each do |i|
    #   i = i.to_s.reverse.chop.reverse
    #   res = self.send i
    #   description += "#{i}: #{res} " if res and i != "type"
    # end
    description += ">"

    description

  end

  def to_geojson
    if self.class == Point
      coords = self.coordinate.to_geojson
    else
      coords = self.coordinates.collect {|c| c.to_geojson}
    end

    propz = {
      type: self.type,
      coordinates: coords
    }
    propz[:properties] = self.properties if self.properties

    JSON.generate propz
  end

end

class Coordinate < Primitive
  attr_accessor :x, :y, :z, :m

  def initialize x, y, z=nil, m=nil
    self.type = "Coordinate"
    self.x, self.y, self.z, self.m = x, y, z, m
  end

  def to_geojson
    [self.x, self.y]
  end

end

class PointArray < Primitive

  def initialize args
    self.type = "PointArray"
    self.coordinates = args
  end

  def add_point c
    self.coordinates << c
  end

end

class Ring < Primitive

  def initialize pointarray
    self.type = "Ring"
    self.coordinates = pointarray
  end

  def add_point c
    self.coordinates << c
  end

end

class Ringlist < Primitive

  attr_accessor :rings

  def initialize rings
    self.type = "Ringlist"
    self.rings = rings
  end

  def add_ring r
    self.rings << r
  end

end

class Point < Geojsonable
  attr_accessor :coordinate

  def initialize coordinate
    self.type = "Point"
    self.coordinate = coordinate
    self.coordinates = [coordinate]
  end

end

class Linestring < Geojsonable

  def initialize pointarray
    self.type = "LineString"
    self.coordinates = pointarray
  end

end

class Polygon < Geojsonable

  attr_accessor :rings, :holes

  def initialize ringlist
    self.type = "Polygon"
    self.coordinates = ringlist.rings.collect { |ring| ring.coordinates } # Kinda janky
    self.rings = ringlist.rings
    self.holes = ringlist.rings[1..ringlist.rings.size] if ringlist.rings.size > 1
  end

end
