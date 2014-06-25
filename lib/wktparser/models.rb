require 'json'

class Primitive
  attr_accessor :type, :properties, :coordinates

  def to_s

    description = "( #{self.type} => "
    self.instance_variables.sort.each do |i|
      i = i.to_s.reverse.chop.reverse
      res = self.send i
      description += "#{i}: #{res} " if res and i != "type"
    end
    description += ")"

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

class Point < Primitive
  attr_accessor :coordinate

  def initialize coordinate
    self.type = "Point"
    self.coordinate = coordinate
    self.coordinates = [coordinate]
  end

end

class Linestring < Primitive

  def initialize pointlist
    self.type = "LineString"
    self.coordinates = pointlist.coordinates
  end

end

class Pointlist < Primitive

  def initialize args
    self.type = "Pointlist"
    self.coordinates = args
  end

  def add_point c
    self.coordinates << c
  end

end

class Ring < Point

  def initialize coordinate
    super
    self.type = "Ring"
  end

end

class Ringlist < Primitive

  def initialize args
    self.type = "Ringlist"
    self.coordinates = args
  end

  def add_ring r
    self.coordinates << r
  end

end

class Polygon < Primitive

  def initialize coordinates
    self.type = "Polygon"
    self.coordinates = coordinates
  end

end
