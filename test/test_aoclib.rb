require_relative "test_helper"

class TestAoclib < Minitest::Test
  def test_globals
    assert_match(/ABC/, ALPHABET.join)
    assert_match(/abc/, ALPHABET_LOWER.join)
    assert_match(/123/, DIGITS.join)
    assert_equal(4, COMPASS.length)
    assert_equal(8, ORDINALS.length)
  end

  def test_banner
    assert_output(/gub/) { banner("gub") }
  end
end
