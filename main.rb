require 'parallel'
require 'minitest/autorun'
require 'pry'

module LineReaderExceptions
  class BracketError < StandardError
    def initialize(message = 'Invalid bracket parens')
      super
    end
  end
end

module LineReader
  include LineReaderExceptions

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

describe 'foo' do
  describe '#check_for_bracket_errors' do
    describe 'raises exception when' do
      it 'brackets contain less than 4 characters' do
        line = 'hello[wor]ld'

        assert_raises(LineReaderExceptions::BracketError) do
          LineReader::check_for_bracket_errors(line)
        end
      end

      it 'brackets are nested' do
        line = '[hello[world]]'

        assert_raises(LineReaderExceptions::BracketError) do
          LineReader::check_for_bracket_errors(line)
        end
      end

      it 'brackets are unclosed' do
        line = 'hello[world'

        assert_raises(LineReaderExceptions::BracketError) do
          LineReader::check_for_bracket_errors(line)
        end
      end
    end
  end

  describe '#valid?' do
    it 'back to back brackets with invalid sequence' do
      line = 'efgh[balab][baab]ommo'

      _(LineReader::valid?(line)).must_equal(false)
    end

    it 'back to back brackets with valid sequeunce' do
      line = 'efgh[balab][blaab]ommo'

      _(LineReader::valid?(line)).must_equal(true)
    end

    it 'sequence must not occur within square brackets - 2' do
      line = 'efgh[baab][baab]ommo'

      _(LineReader::valid?(line)).must_equal(false)
    end

    # efgh[baab]ommo this is invalid (baab is within brackets, ommo outside brackets).
    it 'sequence must not occur within square brackets' do
      line = 'efgh[baab]ommo'

      _(LineReader::valid?(line)).must_equal(false)
    end

    # bbbb[qwer]ereq this is invalid (bbbb is invalid, since the middle two characters should be different.
    it 'sequence must be two pairs of characters' do
      line = 'bbbb[qwer]ereq'

      _(LineReader::valid?(line)).must_equal(false)
    end

    # irttrj[asdfgh]zxcvbn this is valid (rttr is outside square brackets).
    it 'valid sequence occurs outside of square brackets - 1' do
      line = 'irttrj[asdfgh]zxcvbn'

      _(LineReader::valid?(line)).must_equal(true)
    end

    # rttr[mnop]qrst this is valid   (rttr outside square brackets).
    it 'valid sequence occurs outside of square brackets - 2' do
      line = 'rttr[mnop]qrst'

      _(LineReader::valid?(line)).must_equal(true)
    end
  end
end

