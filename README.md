# Wktparser

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'wktparser'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wktparser

## Usage

    # Points!
    stuff = 'point ( 10.05 10.28 )'
    p = Wktparser::Whittler.new
    results = p.parse stuff # #<Point:0x0000010192fdb8 @type="Point", @coordinate=#<Coordinate:0x0000010192fcf0 @type="Coordinate", @x=10.05, @y=10.28, @z=nil, @m=nil>, coordinates[#<Coordinate:0x0000010192fcf0 @type="Coordinate", @x=10.05, @y=10.28, @z=nil, @m=nil>
    puts results.coordinate.x # 10.05
    puts results.coordinate.y # 10.28
    puts results.to_geojson # {"type":"Point","coordinates":[10.05,10.28]}

    # Linestrings!
    TODO

    # Polygons!
    TODO

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
