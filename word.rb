require 'mojinizer'
require 'forwardable'

class Word
  extend Forwardable

  ATTRIBUTES = %i(expression translation kana romaji category jlpt_rating alphabet)
  attr_accessor *ATTRIBUTES

  def_delegators :expression, :hiragana?, :katakana?, :kanji?

  def initialize(**info)
    @expression = info['vocab_expression'].to_s
    @translation = info['vocab_meaning'].to_s
    @kana = info['vocab_kana'].to_s
    @romaji = kana.romaji
    @category = info['vocab_pos'].downcase.to_sym if info['vocab_pos']
    @jlpt_rating = info['jlpt'].to_s.scan(/\d+/).first.to_i

    @alphabet = case expression
                when proc(&:katakana?) then :katakana
                when proc(&:hiragana?) then :hiragana
                when proc(&:kanji?) then :kanji
                else nil
                end
  end

  def info
    ATTRIBUTES.to_h { |attribute| [attribute, public_send(attribute)] }
  end
end
