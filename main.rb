require 'set'
require 'benchmark'

# Динамическое программирование
def cut_string_dp(s, d)
  word_set = d.to_set
  dp = Array.new(s.length + 1, false)
  dp[0] = true

  (1..s.length).each do |i|
    (0...i).each do |j|
      if dp[j] && word_set.include?(s[j...i])
        dp[i] = true
        break
      end
    end
  end

  dp[s.length]
end

# Поиск в ширину (BFS)
def cut_string_bfs(s, d)
  word_set = d.to_set
  queue = [0]
  visited = Set.new

  until queue.empty?
    start = queue.shift
    next if visited.include?(start)

    (start + 1).upto(s.length) do |end_idx|
      substring = s[start...end_idx]
      if word_set.include?(substring)
        return true if end_idx == s.length
        queue << end_idx
      end
    end

    visited.add(start)
  end

  false
end

# тестовые данных
def generate_test_data
  dictionary = ["две", "сотни", "тысячи", "миллионы", "миллиарды", "три", "четыре", "пять"]
  test_strings = []

  # простые случаи
  test_strings << ["двесотни", dictionary]
  test_strings << ["тримиллионы", dictionary]

  # сложные случаи
  test_strings << ["двесотнитримиллионы", dictionary]
  test_strings << ["пятьмиллиардовчетыретысячи", dictionary]

  # очень длинная строка
  long_string = "две" * 1000 + "сотни"
  test_strings << [long_string, dictionary]

  [test_strings, dictionary]
end

# сравнение
def compare_methods
  test_cases, _ = generate_test_data

  test_cases.each_with_index do |(s, dict), index|
    puts "Тестовый случай #{index + 1}: Строка длиной #{s.length}"

    dp_time = Benchmark.realtime do
      result_dp = cut_string_dp(s, dict)
    end

    bfs_time = Benchmark.realtime do
      result_bfs =cut_string_dp(s, dict)
    end

    puts "Dynamik: #{dp_time.round(6)} сек"
    puts "BFS: #{bfs_time.round(6)} сек"
    puts "-" * 40
  end
end

compare_methods
