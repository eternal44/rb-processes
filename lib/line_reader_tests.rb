require_relative 'line_reader'

require 'minitest/autorun'

describe '#main' do
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

    # efgh[baab]ommo this is invalid (baab is within brackets, ommo outside
    # brackets).
    it 'sequence must not occur within square brackets' do
      line = 'efgh[baab]ommo'

      _(LineReader::valid?(line)).must_equal(false)
    end

    # bbbb[qwer]ereq this is invalid (bbbb is invalid, since the middle two
    # characters should be different.
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

