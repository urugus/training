require 'minitest/autorun'

class CalcTest < Minitest::Test
    # 正常系のテスト実行
    def standard_test
        assert_equal calc '1kg + 3kg', '4kg'
        assert_equal calc '1kg + 100g', '1100g'
        assert_equal calc '1kg + 200g - 10mg', '1199990mg'
        assert_equal calc '100g + 2kg * 3', '6100g'
        ssert_equal calc '100g / 4 + 2kg * 3', '6025g'
        assert_equal calc '1kg + 300g / 7', '1042g'
    end

    # 異常系のテスト実行
end




