require_relative 'lib/line_reader.rb'
require 'parallel'
require 'optparse'
require 'pry'

# TODO: receive command line arg for file
# TODO: benchmark:
#  - File.open('filename.txt').each_line.lazy_each
#    - with and without Parallel gem
options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: main.rb [options]"

  opts.on('-t', 'Set thread count for concurrency') do |t|
    options[:thread_count] = t
  end

  opts.on('-f', 'Target file to scan') do |f|
    options[:file] = f
  end

  opts.on('-h', 'Options') do
    puts opts
    exit
  end
end.parse!

file = options.fetch(:file) do
  puts "Target file required. See help menu ('-h') for options"
end

thread_count = options.fetch(:thread_count, 1)

# if __FILE == $0
if __FILE__ == $PROGRAM_NAME

end

# Parallel.each(
#   File.open('prompt/large-sample-data.txt').each_line,
#   in_threads: 6
# ) { |line|
#   puts line if LineReader::valid?(line)
# }

