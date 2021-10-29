
# 演算子の辞書
multi_div = ['*', '/']
plus_minus = ['+', '-']

# エラーコードと内容のリスト
error_dict = {
  'ValueError': 'first argument must be weight-value (ex: 1kg) (ArgumentError)',
  'UnitError': 'the unit must be one of mg,g,kg (ArgumentError)',
  'OperatorError': 'multiplier & divisor must be a number at "* , /"'
}

# 実行関数
def calc(input)
  # 単位の辞書
  unit_dict = {'kg': 1000000, 'g': 1000, 'mg': 1}
  min_sym = :kg
  # 半角スペースで分割して配列に格納
  input_list = input.split

  #  計算を実行
  input_list.each do |content|
    # 質量を最小単位に変換
    unit_dict.keys.each do |symbol|
      magni = unit_dict[symbol]
      unit = symbol.to_s
      # リストにない単位の場合エラーを出す
      if value = /(\d+)#{unit}/.match(content)
        puts value[0].to_i * magni
        # 最小の単位を記憶
        if unit_dict[symbol] < unit_dict[min_sym]
          min_sym = symbol
        end
      end

    end
    puts min_sym
  end
  # 乗除を実行
    # 質量 × 数値以外の場合はエラーを出す
  # 加減を実行
  # 単位を付け直す
    # 単位の辞書を参照し、記憶しておいた最小単位の値で割る
    # 最小単位をつけて文字列に変換
end

puts calc('1kg + 3g')