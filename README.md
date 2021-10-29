[![Build Status](https://github.com/gurgeous/aoclib/workflows/test/badge.svg?branch=main)](https://github.com/gurgeous/aoclib/actions)

![logo](logo.svg)

# aoclib

aoclib is a collection of Ruby helpers for solving [Advent of Code](https://adventofcode.com) puzzles. I've had these hanging around in my personal collection. After reaching 300 stars I decided to clean them up and release as a gem.

Philosophy - Unlike regular Ruby gems, most helpers are added to the global namespace or monkeypatched into standard Ruby classes. I prefer things this way when I'm trying to work quickly. Also, DRY is not important because it can make it harder to quickly figure out how the helpers work. This gem is only for Advent of Code! Don't write real gems this way.

### Highlights

- [HardGrid](https://github.com/gurgeous/aoclib/blob/main/lib/hard_grid.rb) and [SoftGrid](https://github.com/gurgeous/aoclib/blob/main/lib/soft_grid.rb) classes for reading and walking maps, AOC style. "Hard" grids have well defined dimensions, like dungeons. "Soft" grids can grow over time, like game of life. These grids can be constructed from map strings and pretty printed. Internal storage is a hash.

- [Point](https://github.com/gurgeous/aoclib/blob/main/lib/point.rb) and [Point3](https://github.com/gurgeous/aoclib/blob/main/lib/point3.rb) for following compass (N, E, S, W) and calculating neighbors.

- [Deque](https://github.com/gurgeous/aoclib/blob/main/lib/deque.rb), like the one in Python. A doubly linked list. Operations at head and tail are fast, everything else is slow. Supports rotate. 200 elves are sitting around a table...

- [Numpy](https://github.com/gurgeous/aoclib/blob/main/lib/core_ext/numpy.rb)-style helpers for Array. You can reshape, rotate, flip, roll, concatenate, etc. Only works with 2d.

- [PriorityQueue](https://github.com/gurgeous/aoclib/blob/main/lib/priority_queue.rb) for [A* search](https://en.wikipedia.org/wiki/A*_search_algorithm).

- [deep_dup](https://github.com/gurgeous/aoclib/blob/main/lib/core_ext/deep_dup.rb) for making copies of arrays, hashes, sets, etc.

Oh, and if your main Ruby file is named `17.rb` call `aocinput` to read the contents of `17.txt`.

### Core Extensions

Here are some of the more helpful extensions:

- [Array](https://github.com/gurgeous/aoclib/blob/main/lib/core_ext/array.rb): Manhattan distance, neighbors (N, E, S, W)
- [Enumerable](https://github.com/gurgeous/aoclib/blob/main/lib/core_ext/enumerable.rb): identical? and most_common
- [Hash](https://github.com/gurgeous/aoclib/blob/main/lib/core_ext/hash.rb): Sort by key/value, or reverse
- [Integer](https://github.com/gurgeous/aoclib/blob/main/lib/core_ext/integer.rb): prime mixins, digit access, reverse
- [String](https://github.com/gurgeous/aoclib/blob/main/lib/core_ext/string.rb): extract all ints/floats, MD5

## Quick Example

```ruby
>> GRID =<<EOF.freeze
################
#.....#.......A#
#..####..#..####
#........#..#..#
##########..#..#
#...........#..#
#..#..####..#..#
#..#.....#.....#
#..##########..#
#..#........#..#
#..#..####..#..#
#.....#.....#..#
#..####..####..#
#....Z#..#.....#
################
EOF

>> grid = HardGrid.from_string(GRID)
=> <HardGrid 15x16>

>> grid.print(header: true)
==>
   0000000000111111
   0123456789012345
00 ################ 00
01 #.....#.......A# 01
02 #..####..#..#### 02
03 #........#..#..# 03
04 ##########..#..# 04
05 #...........#..# 05
06 #..#..####..#..# 06
07 #..#.....#.....# 07
08 #..##########..# 08
09 #..#........#..# 09
10 #..#..####..#..# 10
11 #.....#.....#..# 11
12 #..####..####..# 12
13 #....Z#..#.....# 13
14 ################ 14
   0123456789012345
   0000000000111111

>> grid.shortest_path_length(grid.find('A'), grid.find('Z'))
=> 27
```

## Changelog

#### 0.1 - Nov 2021

- Original release