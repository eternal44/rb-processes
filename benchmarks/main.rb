require_relative '../lib/line_reader'
require 'parallel'
require 'benchmark'

def reading(thread_count)
  relative_path = '../input-files/benchmark-input.txt'
  file_path = File.expand_path(relative_path, File.dirname(__FILE__))

  Parallel.each(
    File.open(file_path).each_line,
    in_threads: thread_count
  ) { |line|
    LineReader::valid?(line)
  }
end

Benchmark.bm(9) do |x|
  x.report('1 thread') do
    reading(1)
  end

  x.report('6 threads') do
    reading(6)
  end
end

