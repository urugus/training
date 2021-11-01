# 配列と単位を与えると最小単位に直した配列と最小単位を返す関数
def change_min_unit(input_list, unit_dict, unit_list, min_sym)
  output_list = []
  error_sym = nil
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


# 配列を与えると乗算を実行して返す関数
def multiply(input_list)
  oper_index = input_list.index('*')
  unless oper_index.nil?
    product = input_list[oper_index + 1].to_i
    multiplicand = input_list[oper_index - 1]
    # 被乗数を置換し、演算子と乗数を削除
    input_list[oper_index - 1] = multiplicand * product
    input_list.delete_at(oper_index)
    input_list.delete_at(oper_index)
    multiply(input_list)
  end
  # 質量 × 数値以外の場合はエラーを出す
  return input_list 
end


# 配列を与えると除算を実行して返す関数
def divide(input_list)
  oper_index = input_list.index('/')
  unless oper_index.nil?
    product = input_list[oper_index + 1].to_i
    multiplicand = input_list[oper_index - 1]
    # 被除数を置換し、演算子と除数を削除
    input_list[oper_index - 1] = multiplicand / product
    input_list.delete_at(oper_index)
    input_list.delete_at(oper_index)
    multiply(input_list)
  end
  # 質量 × 数値以外の場合はエラーを出す
  return input_list 
end


# 加減算を実行する関数
def add_all(input_list)
  list_len = input_list.length
  input_list.insert(0, '+')
  plus_sum = 0
  minus_sum = 0
  0.upto(list_len) {|i|
  if input_list[i] == '+'
    plus_sum += input_list[i+1]
  elsif input_list[i] == '-'
    minus_sum += input_list[i+1]
  end
  }
  return plus_sum - minus_sum
end



# 実行関数
def calc(input)

  # 単位の辞書
  unit_dict = {'kg': 1000000, 'g': 1000, 'mg': 1}
  unit_list = ['kg','g','mg']

  # エラーコードと内容のリスト
  error_dict = {
    'ValueError': 'first argument must be weight-value (ex: 1kg) (ArgumentError)',
    'UnitError': 'the unit must be one of mg,g,kg (ArgumentError)',
    'OperatorError': 'multiplier & divisor must be a number at "* , /"'
  }

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
  # puts output_list.to_s

  # 乗除を実行
  output_list = multiply(output_list)
  output_list = divide(output_list)
  # puts output_list.to_s

  # 加減を実行
  ans_value = add_all(output_list)
  # puts ans_value

  # 単位の辞書を参照し、記憶しておいた最小単位の値で割る
  ans_weight = ans_value.to_f / unit_dict[min_sym]

  # 最小単位をつけて文字列に変換
  anser = ans_weight.to_i.to_s + min_sym.to_s

  # エラーがあればエラーを、なければ答えを出力
  if error_sym.nil?
    return anser
  else
    return error_dict[error_sym]
  end
end

puts calc('1kg + 300g / 7')