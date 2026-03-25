require "json"

data = JSON.parse(File.read("data/plurimath-failing-expressions.json"))

# Group by element signature
by_elements = data.group_by { |d| d["elements"].join(", ") }
puts "#{data.count} unique patterns in #{by_elements.count} element groups:\n"

by_elements.each do |elements, items|
  puts "Elements: #{elements}"
  puts "  Count: #{items.count}"
  items.first(3).each do |item|
    puts "    #{item['file']}: [#{item['text']}]"
  end
  puts
end
