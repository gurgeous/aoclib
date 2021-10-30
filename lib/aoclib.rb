#
# load our stuff
#

require_relative 'core_ext'
require_relative 'deque'
require_relative 'hard_grid'
require_relative 'point'
require_relative 'point3'
require_relative 'priority_queue'
require_relative 'soft_grid'

#
# TODO
# - tests for grids and points
# - patrick?
#

#
# constants
#

# uppercase alphabet, as array
ALPHABET = ('A'..'Z').to_a.freeze

# lowercase alphabet, as array
ALPHABET_LOWER = ('a'..'z').to_a.freeze

# digits, as array
DIGITS = (0..9).to_a.freeze

# NESW compass directions
COMPASS = [
  [0, -1], # N
  [1, 0], # E
  [0, 1], # S
  [-1, 0], # W
].freeze

# NW N NE E SE S SW W ordinal directions
ORDINALS = [
  [-1, -1], # NW
  [0, -1], # N
  [1, -1], # NE
  [1, 0], # E
  [1, 1], # SE
  [0, 1], # S
  [-1, 1], # SW
  [-1, 0], # W
].freeze

#
# global methods
#

# read xxx.txt based on the current ruby file name
def aoc_input
  IO.read("#{$PROGRAM_NAME[/\d+/]}.txt")
end

# print a nice green banner
def banner(s)
  green, reset = "\e[1;37;42m", "\e[0m"

  s = "#{s} ".ljust(72, ' ')
  $stdout.write "#{green}[#{Time.new.strftime('%H:%M:%S')}] #{s}#{reset}\n"
  $stdout.flush
end
