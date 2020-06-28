require_relative 'lib/line_reader.rb'
require 'parallel'
require 'optparse'
# require 'mutex'

options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: main.rb [options]"

  opts.on('-t ') do |t|
    options[:thread_count] = t.to_i
  end

  opts.on('-f ', 'Path to target file to scan') do |f|
    options[:file_path] = f
  end

  opts.on('-h', 'Print options') do
    puts opts

    exit
  end
end.parse!

if __FILE__ == $PROGRAM_NAME
  file_path = options.fetch(:file_path) do
    puts "Target file required. See help menu ('-h') for options"
  end

  thread_count = options.fetch(:thread_count, 1)

  mutex = Mutex.new
  line_count = 0

  Parallel.each(
    File.open(file_path).each_line,
    in_threads:thread_count
  ) { |line|
    next if line.empty?

    if LineReader::valid?(line)
      mutex.lock

      line_count += 1

      mutex.unlock
      puts line
    end
  }

  p line_count
end
