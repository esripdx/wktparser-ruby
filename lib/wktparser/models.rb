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
    JSON.generate({
      type: self.type,
      coordinates: self.coordinates,
      properties: self.properties
    })
  end

end

class Coordinate < Primitive
  attr_accessor :x, :y, :z, :m

  def initialize x, y, z=nil, m=nil
    self.type = "Coordinate"
    self.x, self.y, self.z, self.m = x, y, z, m
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
