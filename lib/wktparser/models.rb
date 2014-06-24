class Primitive
  attr_accessor :type

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
  end

end
