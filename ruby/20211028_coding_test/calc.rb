
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
  unit_list = ['kg','g','mg']

  min_sym = :kg
  # 入力内容を半角スペースで分割して配列に格納
  input_list = input.split
  # 途中経過のリストを用意
  output_list = []

  #  計算を実行
  input_list.each do |content|
    # 質量の場合、数値と単位に分解
    if mass = /(\d+)([a-z]+)/.match(content)
      value = mass[1].to_i
      unit = mass[2]
      # リストにある単位の場合、最小単位に変換する
      if unit_list.include?(unit)
        unit_sym = unit.to_sym
        changed_mass = "#{(value * unit_dict[unit_sym]).to_s}mg"
        # 最小の単位を記憶
        if unit_dict[unit_sym] < unit_dict[min_sym]
          min_sym = unit_sym
        end
        # 配列を上書きする
        output_list.push(changed_mass)
      # リストにない単位の場合エラーを出す
      else
        # シンボルエラーをセット
        puts "symbol error"
      end
    else
      output_list.push(content)

    end
  end
  # 乗除を実行
    # 質量 × 数値以外の場合はエラーを出す
  # 加減を実行
  # 単位を付け直す
    # 単位の辞書を参照し、記憶しておいた最小単位の値で割る
    # 最小単位をつけて文字列に変換
    # puts min_sym.to_s
  puts output_list.to_s
end

calc('1kg + 3g')