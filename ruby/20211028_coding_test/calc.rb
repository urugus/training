# エラーコードと内容のリスト
error_dict = {
  'ValueError': 'first argument must be weight-value (ex: 1kg) (ArgumentError)',
  'UnitError': 'the unit must be one of mg,g,kg (ArgumentError)',
  'OperatorError': 'multiplier & divisor must be a number at "* , /"'
}

# 配列と単位を与えると最小単位に直した配列と最小単位を返す関数
def change_min_unit(input_list, unit_dict, unit_list, min_sym)
  output_list = []
  error_sym = ''
  input_list.each do |content|
    # 質量の場合、数値と単位に分解
    if mass = /(\d+)([a-z]+)/.match(content)
      value = mass[1].to_i
      unit = mass[2]
      # リストにある単位の場合、最小単位に変換する
      if unit_list.include?(unit)
        unit_sym = unit.to_sym
        unit_magni = unit_dict[unit_sym]
        min_unit_value = value * unit_magni
        # 最小の単位を記憶
        if unit_dict[unit_sym] < unit_dict[min_sym]
          min_sym = unit_sym
        end
        # 配列を上書きする
        output_list.push(min_unit_value)
      # リストにない単位の場合エラーを返す
      else
        # エラーをセット
        error_sym = :UnitError
      end
    # 質量以外の場合はそのまま配列に追加
    else
      output_list.push(content)
    end
  end
  return {list: output_list, min_sym: min_sym, error_sym: error_sym}
end


# 配列を与えると乗除を実行して返す関数
def multiply(input_list)
  oper_index = input_list.index('*')
  unless oper_index.nil?
    product = input_list[oper_index + 1].to_i
    multiplicand = input_list[oper_index - 1]
    # 被乗数を置換
    input_list[oper_index - 1] = multiplicand * product
    input_list.delete_at(oper_index)
    input_list.delete_at(oper_index)
    multiply(input_list)
  end
  # 質量 × 数値以外の場合はエラーを出す
  return input_list 
end


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

  # 配列のインデックス
  index = 0

  # 質量の場合、数値と単位に分解
  unit_changed_result = change_min_unit(
    input_list, unit_dict, unit_list, min_sym
    )
  output_list = unit_changed_result[:list]
  min_sym = unit_changed_result[:min_sym]
  error_sym = unit_changed_result[:error_sym]
  
  puts output_list.to_s

  # 乗除を実行
  output_list = multiply(output_list)

    # end
  # 加減を実行
  # 単位を付け直す
    # 単位の辞書を参照し、記憶しておいた最小単位の値で割る
    # 最小単位をつけて文字列に変換
    # puts min_sym.to_s
  puts output_list.to_s
  puts error_sym
  puts min_sym
end

calc('1kg * 4 + 3g * 3 * 3')