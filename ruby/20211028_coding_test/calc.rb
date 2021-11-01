# 配列と単位を与えると最小単位に直した配列と最小単位を返す関数
def change_min_unit(input_list, unit_dict, min_sym)
  output_list = []
  input_list.each do |content|
    # 質量の場合、数値と単位に分解
    if mass = /(\d+)([a-z]+)/.match(content)
      value = mass[1].to_i
      unit = mass[2]
      # 最小単位に変換する
      unit_sym = unit.to_sym
      unit_magni = unit_dict[unit_sym]
      min_unit_value = value * unit_magni
      # 最小の単位を記憶
      if unit_dict[unit_sym] < unit_dict[min_sym]
        min_sym = unit_sym
      end
      # 配列を上書きする
      output_list.push(min_unit_value)
    # 質量以外の場合はそのまま配列に追加
    else
      output_list.push(content)
    end
  end
  return {list: output_list, min_sym: min_sym}
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


# 先頭が質量かどうかをチェックする関数
def first_element_is_mass?(input_list)
  first_element = input_list[0]
  if mass = /(\d+)([a-z]+)/.match(first_element)
    return true
  else
    return false
  end
end

# 使用できない単位を使用しているかどうかチェックする関数
def all_unit_is_available?(input_list, unit_list)
  error_sym = nil
  ans = true
  input_list.each do |content|
    if mass = /(\d+)([a-z]+)/.match(content)
      value = mass[1].to_i
      unit = mass[2]
      unless unit_list.include?(unit)
        ans = false
        break
      end
    end
  end
  return ans
end

# '*'、'/'の後ろが数値かどうかをチェックする関数
def after_operator_is_a_number?(input_list)
  error_sym = nil
  ans = true
  list_len = input_list.length
  0.upto(list_len) {|i|
    if input_list[i] == '*' || input_list[i] == '/'
      begin
        unless input_list[i+1].to_i.to_s == input_list[i+1]
          ans = false
        end
      rescue
        ans = false
      end
    end
  }
  return ans
end


# 実行関数
def calc(input)

  # 単位の辞書
  unit_dict = {'kg': 1000000, 'g': 1000, 'mg': 1}
  unit_list = ['kg','g','mg']
  min_sym = :kg
  
  # エラーコードと内容のリスト
  error_dict = {
    'ValueError': 'first argument must be weight-value (ex: 1kg) (ArgumentError)',
    'UnitError': 'the unit must be one of mg,g,kg (ArgumentError)',
    'OperatorError': 'multiplier & divisor must be a number at "* , /" (ArgumentError)'
  }
  
  
  # 入力内容を半角スペースで分割して配列に格納
  input_list = input.split
  
  # 入力内容をテスト
  error_sym = nil
  unless first_element_is_mass?(input_list)
    error_sym = :ValueError
  end
  unless all_unit_is_available?(input_list, unit_list)
    error_sym = :UnitError
  end
  unless after_operator_is_a_number?(input_list)
    error_sym = :OperatorError
  end
  
  unless error_sym.nil?
    return 'error: ' + error_dict[error_sym]
  else
    # 途中経過のリストを用意
    output_list = []

    # 質量の場合、数値と単位に分解
    unit_changed_result = change_min_unit(
      input_list, unit_dict, min_sym
      )
    output_list = unit_changed_result[:list]
    min_sym = unit_changed_result[:min_sym]

    # 乗除を実行
    output_list = multiply(output_list)
    output_list = divide(output_list)

    # 加減を実行
    ans_value = add_all(output_list)

    # 単位の辞書を参照し、記憶しておいた最小単位の値で割る
    ans_weight = ans_value.to_f / unit_dict[min_sym]

    # 最小単位をつけて文字列に変換
    answer = ans_weight.to_i.to_s + min_sym.to_s

    return answer
  end
end

puts calc('1kg + 300g / 7').to_s