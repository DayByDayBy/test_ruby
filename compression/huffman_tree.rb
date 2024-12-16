require 'json'
require 'set'

def read_file(filename)
  File.read(filename)
end

def write_file(filename, encoded_text, codes)
  File.open(filename, 'w') do |file|
    file.write(encoded_text.join)
    file.write("\n")
    codes.each do |char, code|
      file.write("#{char}: #{code}\n")
    end
  end
end

def build_huffman_tree(freq_dict)
  heap = freq_dict.map { |sym, wt| [wt, [sym, '']] }
  heap = heap.sort_by { |node| node[0] }

  while heap.size > 1
    lo = heap.shift
    hi = heap.shift
    lo[1..-1].each { |pair| pair[1] = '0' + pair[1] }
    hi[1..-1].each { |pair| pair[1] = '1' + pair[1] }
    heap << [lo[0] + hi[0], *lo[1..-1], *hi[1..-1]]
    heap = heap.sort_by { |node| node[0] }
  end

  heap.shift[1..-1].sort_by { |pair| [pair[1].length, pair[0]] }
end

def huffman_encode(input_filename, output_filename)
  text = read_file(input_filename)
  freq_dict = text.chars.tally
  codes = build_huffman_tree(freq_dict).to_h
  encoded_text = text.chars.map { |char| codes[char] }
  write_file(output_filename, encoded_text, codes)
end

input_filename = 'lorem.txt'
output_filename = 'ruby_huffman_encoded.txt'
huffman_encode(input_filename, output_filename)
