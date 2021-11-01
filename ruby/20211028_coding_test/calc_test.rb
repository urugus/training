require 'minitest/autorun'
require './calc'

class CalcTest < Minitest::Test
    # 正常系のテスト実行
    def test_standard
        assert_equal '4kg', calc('1kg + 3kg')
        assert_equal '1100g', calc('1kg + 100g')
        assert_equal '1199990mg', calc('1kg + 200g - 10mg')
        assert_equal '6100g', calc('100g + 2kg * 3')
        assert_equal '6025g', calc('100g / 4 + 2kg * 3')
        assert_equal '1042g', calc('1kg + 300g / 7')
        assert_equal '4042g', calc('1kg * 2 * 2 + 300g / 7')
    end

    # 異常系のテスト実行
    def test_irregular
        assert_equal 'first argument must be weight-value (ex: 1kg)
        (ArgumentError)', calc('+ 3g + 100mg')
        assert_equal 'error: the unit must be one of mg,g,kg (ArgumentError)',
         calc('1kg + 3t')
        assert_equal 'error: multiplier & divisor must be a number at "* , /"
        (ArgumentError)', calc('1kg * 3g')
    end
end




