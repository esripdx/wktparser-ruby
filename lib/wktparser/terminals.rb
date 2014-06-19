module Wktparser
  class Parser
    TERMINALS = {
      2=> "error",
      4=> "NUMBER",
      11=> "EOF",
      23=> "POINT",
      25=> "LINESTRING",
      27=> "POLYGON",
      29=> "TRIANGLE",
      30=> "triangle_text",
      31=> "POLYHEDRALSURFACE",
      33=> "TIN",
      34=> "tin_text",
      35=> "MULTIPOINT",
      37=> "MULTILINESTRING",
      39=> "MULTIPOLYGON",
      41=> "GEOMETRYCOLLECTION",
      43=> "EMPTY_SET",
      44=> "(",
      45=> ")",
      47=> ",",
      64=> "Z",
      68=> "triangle_text_z",
      70=> "tin_text_z",
      92=> "M",
      96=> "triangle_text_m",
      98=> "tin_text_m",
      120=> "ZM",
      124=> "triangle_text_zm",
      126=> "tin_text_zm"
    }
  end
end
