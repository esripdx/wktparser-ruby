/*
 * Description: WKT Grammar
 *
 * Based on OGC document 06-103r4:
 * OpenGIS Implementation Standard for Geographic information
 * - Simple feature access
 *   - Part 1: Common architecture (Version 1.2.1)
 *
 * Copyright (c) 2011 James Watmuff
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
 * associated documentation files (the "Software"), to deal in the Software without restriction,
 * including without limitation the rights to use, copy, modify, merge, publish, distribute,
 * sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or
 * substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
 * NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
 * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 */

%lex

NUM	(([0-9]+([.,][0-9]*)?)|([.,][0-9]+))

%%
\s+                             /* skip whitespace */
"POINT"	                        return 'POINT';
"LINESTRING"                    return 'LINESTRING';
"POLYGON"                       return 'POLYGON';
"TRIANGLE"                      return 'TRIANGLE';
"POLYHEDRALSURFACE"             return 'POLYHEDRALSURFACE';
"TIN"                           return 'TIN';
"MULTIPOINT"                    return 'MULTIPOINT';
"MULTILINESTRING"               return 'MULTILINESTRING';
"MULTIPOLYGON"                  return 'MULTIPOLYGON';
"GEOMETRYCOLLECTION"            return 'GEOMETRYCOLLECTION';
"EMPTY"                         return 'EMPTY_SET';
"MZ"                            return 'MZ';
"M"                             return 'M';
"Z"                             return 'Z';
"("                             return '(';
")"                             return ')';
","                             return ',';
([-+]?{NUM})([E][-+]?[0-9]+)?   return 'NUMBER';
<<EOF>>                         return 'EOF';

/lex

%start file

%% /* language grammar */

x
	: NUMBER
	;

y
	: NUMBER
	;

z
	: NUMBER
	;

m
	: NUMBER
	;
	

point
	: x y
	;
	
file
	: geometry_tts EOF
	;
	
geometry_tts
	: geometry_tt
	| geometry_tt geometry_tts
	;

geometry_tt
	: point_tt
	| linestring_tt
	| polygon_tt
	| triangle_tt
	| polyhedralsurface_tt
	| tin_tt
	| multipoint_tt
	| multilinestring_tt
	| multipolygon_tt
	| geometrycollection_tt
	;

point_tt
	: POINT point_text
	;

linestring_tt
	: LINESTRING linestring_text
	;

polygon_tt
	: POLYGON polygon_text
	;

triangle_tt
	: TRIANGLE triangle_text
	;

polyhedralsurface_tt
	: POLYHEDRALSURFACE polyhedralsurface_text
	;

tin_tt
	: TIN tin_text
	;

multipoint_tt
	: MULTIPOINT multipoint_text
	;

multilinestring_tt
	: MULTILINESTRING multilinestring_text
	;

multipolygon_tt
	: MULTIPOLYGON multipolygon_text
	;

geometrycollection_tt
	: GEOMETRYCOLLECTION geometrycollection_text
	;

point_text
	: EMPTY_SET
	| '(' point ')'
	;

point_list
	: point
	| point ',' point_list
	;
	
linestring_text
	: EMPTY_SET
	| '(' point_list ')'
	;

linestring_text_list
	: linestring_text
	| linestring_text ',' linestring_text_list
	;
	
polygon_text
	: EMPTY_SET
	| '(' linestring_text_list ')'
	;
	
polygon_text_list
	: polygon_text
	| polygon_text ',' polygon_text
	;

polyhedralsurface_text
	: EMPTY_SET
	| '(' polygon_text_list ')'
	;

point_text_list
	: point_text
	| point_text ',' point_text_list
	;

multipoint_text
	: EMPTY_SET
	| '(' point_text_list ')'
	| '(' point_list ')' /* Non-standard but widely used */
	;

multilinestring_text
	: EMPTY_SET
	| '(' linestring_text_list ')'
	;

multipolygon_text
	: EMPTY_SET
	| '(' polygon_text_list ')'
	;

geometry_tt_list
	: geometry_tt
	| geometry_tt ',' geometry_tt_list
	;

geometrycollection_text
	: EMPTY_SET
	| '(' geometry_tt_list ')'
	;

/* 3D Geometry */


point_z
	: x y z
	;

geometry_tt_z
	: point_tt_z
	| linestring_tt_z
	| polygon_tt_z
	| triangle_tt_z
	| polyhedralsurface_tt_z
	| tin_tt_z
	| multipoint_tt_z
	| multilinestring_tt_z
	| multipolygon_tt_z
	| geometrycollection_tt_z
	;

point_tt_z
	: POINT Z point_text_z
	;

linestring_tt_z
	: LINESTRING Z linestring_text_z
	;

polygon_tt_z
	: POLYGON Z polygon_text_z
	;

triangle_tt_z
	: TRIANGLE Z triangle_text_z
	;

polyhedralsurface_tt_z
	: POLYHEDRALSURFACE Z polyhedralsurface_text_z
	;

tin_tt_z
	: TIN Z tin_text_z
	;

multipoint_tt_z
	: MULTIPOINT Z multipoint_text_z
	;

multilinestring_tt_z
	: MULTILINESTRING Z multilinestring_text_z
	;

multipolygon_tt_z
	: MULTIPOLYGON Z multipolygon_text_z
	;

geometrycollection_tt_z
	: GEOMETRYCOLLECTION Z geometrycollection_text_z
	;

point_text_z
	: EMPTY_SET
	| '(' point_z ')'
	;

point_list_z
	: point_z
	| point_z ',' point_list_z
	;
	
linestring_text_z
	: EMPTY_SET
	| '(' point_list_z ')'
	;

linestring_text_list_z
	: linestring_text_z
	| linestring_text_z ',' linestring_text_list_z
	;
	
polygon_text_z
	: EMPTY_SET
	| '(' linestring_text_list_z ')'
	;
	
polygon_text_list_z
	: polygon_text_z
	| polygon_text_z ',' polygon_text_z
	;

polyhedralsurface_text_z
	: EMPTY_SET
	| '(' polygon_text_list_z ')'
	;

point_text_list_z
	: point_text_z
	| point_text_z ',' point_text_list_z
	;

multipoint_text_z
	: EMPTY_SET
	| '(' point_text_list_z ')'
	;

multilinestring_text_z
	: EMPTY_SET
	| '(' linestring_text_list_z ')'
	;

multipolygon_text_z
	: EMPTY_SET
	| '(' polygon_text_list_z ')'
	;

geometry_tt_list_z
	: geometry_tt_z
	| geometry_tt_z ',' geometry_tt_list_z
	;

geometrycollection_text_z
	: EMPTY_SET
	| '(' geometry_tt_list_z ')'
	;

/* 2D Measured Geometry */


point_m
	: x y m
	;

geometry_tt_m
	: point_tt_m
	| linestring_tt_m
	| polygon_tt_m
	| triangle_tt_m
	| polyhedralsurface_tt_m
	| tin_tt_m
	| multipoint_tt_m
	| multilinestring_tt_m
	| multipolygon_tt_m
	| geometrycollection_tt_m
	;

point_tt_m
	: POINT M point_text_m
	;

linestring_tt_m
	: LINESTRING M linestring_text_m
	;

polygon_tt_m
	: POLYGON M polygon_text_m
	;

triangle_tt_m
	: TRIANGLE M triangle_text_m
	;

polyhedralsurface_tt_m
	: POLYHEDRALSURFACE M polyhedralsurface_text_m
	;

tin_tt_m
	: TIN M tin_text_m
	;

multipoint_tt_m
	: MULTIPOINT M multipoint_text_m
	;

multilinestring_tt_m
	: MULTILINESTRING M multilinestring_text_m
	;

multipolygon_tt_m
	: MULTIPOLYGON M multipolygon_text_m
	;

geometrycollection_tt_m
	: GEOMETRYCOLLECTION M geometrycollection_text_m
	;

point_text_m
	: EMPTY_SET
	| '(' point_m ')'
	;

point_list_m
	: point_m
	| point_m ',' point_list_m
	;
	
linestring_text_m
	: EMPTY_SET
	| '(' point_list_m ')'
	;

linestring_text_list_m
	: linestring_text_m
	| linestring_text_m ',' linestring_text_list_m
	;
	
polygon_text_m
	: EMPTY_SET
	| '(' linestring_text_list_m ')'
	;
	
polygon_text_list_m
	: polygon_text_m
	| polygon_text_m ',' polygon_text_m
	;

polyhedralsurface_text_m
	: EMPTY_SET
	| '(' polygon_text_list_m ')'
	;

point_text_list_m
	: point_text_m
	| point_text_m ',' point_text_list_m
	;

multipoint_text_m
	: EMPTY_SET
	| '(' point_text_list_m ')'
	;

multilinestring_text_m
	: EMPTY_SET
	| '(' linestring_text_list_m ')'
	;

multipolygon_text_m
	: EMPTY_SET
	| '(' polygon_text_list_m ')'
	;

geometry_tt_list_m
	: geometry_tt_m
	| geometry_tt_m ',' geometry_tt_list_m
	;

geometrycollection_text_m
	: EMPTY_SET
	| '(' geometry_tt_list_m ')'
	;

/* 3D Measured Geometry */


point_zm
	: x y z m
	;

geometry_tt_zm
	: point_tt_zm
	| linestring_tt_zm
	| polygon_tt_zm
	| triangle_tt_zm
	| polyhedralsurface_tt_zm
	| tin_tt_zm
	| multipoint_tt_zm
	| multilinestring_tt_zm
	| multipolygon_tt_zm
	| geometrycollection_tt_zm
	;

point_tt_zm
	: POINT ZM point_text_zm
	;

linestring_tt_zm
	: LINESTRING ZM linestring_text_zm
	;

polygon_tt_zm
	: POLYGON ZM polygon_text_zm
	;

triangle_tt_zm
	: TRIANGLE ZM triangle_text_zm
	;

polyhedralsurface_tt_zm
	: POLYHEDRALSURFACE ZM polyhedralsurface_text_zm
	;

tin_tt_zm
	: TIN ZM tin_text_zm
	;

multipoint_tt_zm
	: MULTIPOINT ZM multipoint_text_zm
	;

multilinestring_tt_zm
	: MULTILINESTRING ZM multilinestring_text_zm
	;

multipolygon_tt_zm
	: MULTIPOLYGON ZM multipolygon_text_zm
	;

geometrycollection_tt_zm
	: GEOMETRYCOLLECTION ZM geometrycollection_text_zm
	;

point_text_zm
	: EMPTY_SET
	| '(' point_zm ')'
	;

point_list_zm
	: point_zm
	| point_zm ',' point_list_zm
	;
	
linestring_text_zm
	: EMPTY_SET
	| '(' point_list_zm ')'
	;

linestring_text_list_zm
	: linestring_text_zm
	| linestring_text_zm ',' linestring_text_list_zm
	;
	
polygon_text_zm
	: EMPTY_SET
	| '(' linestring_text_list_zm ')'
	;
	
polygon_text_list_zm
	: polygon_text_zm
	| polygon_text_zm ',' polygon_text_zm
	;

polyhedralsurface_text_zm
	: EMPTY_SET
	| '(' polygon_text_list_zm ')'
	;

point_text_list_zm
	: point_text_zm
	| point_text_zm ',' point_text_list_zm
	;

multipoint_text_zm
	: EMPTY_SET
	| '(' point_text_list_zm ')'
	;

multilinestring_text_zm
	: EMPTY_SET
	| '(' linestring_text_list_zm ')'
	;

multipolygon_text_zm
	: EMPTY_SET
	| '(' polygon_text_list_zm ')'
	;

geometry_tt_list_zm
	: geometry_tt_zm
	| geometry_tt_zm ',' geometry_tt_list_zm
	;

geometrycollection_text_zm
	: EMPTY_SET
	| '(' geometry_tt_list_zm ')'
	;
