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
    end

    # 異常系のテスト実行
    def test_irregular
    end
end




