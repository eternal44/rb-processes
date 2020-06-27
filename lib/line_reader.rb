module LineReaderExceptions
  class BracketError < StandardError
    def initialize(message = 'Invalid bracket parens')
      super
    end
  end
end

module LineReader
  include LineReaderExceptions

  # returns boolean if line contains valid sequence
  def self.valid?(line)
    slow = 0
    fast = 3
    inside_brackets = false
    sequence_found_outside_brackets = false

    while fast < line.length
      # "jumps" into or out of brackets
      if line[fast] == '[' || line[fast] == ']'
        fast += 4
        slow += 4

        inside_brackets = !inside_brackets

        next
      end

      # handles back to back brackets
      if line[slow] == '['
        fast += 1
        slow += 1

        inside_brackets = true

        next
      end

      sequence_found = valid_sequence?(line, slow, fast)

      return false if sequence_found && inside_brackets

      sequence_found_outside_brackets = true if sequence_found

      fast += 1
      slow += 1
    end

    sequence_found_outside_brackets
  end

  # raises exception based on working assumptions for how lines are formatted
  def self.check_for_bracket_errors(line)
    parens = 0
    char_count = 0

    line.chars.each do |char|

      if char == '['
        parens += 1
        char_count = 0
      end

      if char == ']'
        parens -= 1

        raise BracketError, 'Not enough characters' if char_count < 4
      end

      raise BracketError, 'Nested brackets' if parens < 0 || parens > 1
    end

    raise BracketError, 'Unclosed brackets' unless parens.zero?

    char_count += 1
  end

  private

  def self.valid_sequence?(line, slow, fast)
    line[slow] == line[fast] &&
      line[slow + 1] == line[fast - 1] &&
      line[slow] != line[slow + 1]
  end
end
