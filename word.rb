require 'mojinizer'
require 'forwardable'

# Note: Kanji gets sorted into the :hiragana library

class Word
  extend Forwardable

  ATTRIBUTES = %i(expression translation kana romaji category jlpt_rating alphabet expression_audio_path)
  attr_accessor *ATTRIBUTES

  def_delegators :expression, :hiragana?, :katakana?, :kanji?, :contains_kanji?, :contains_hiragana?, :contains_katakana?

  def initialize(**info)
    @expression = info['vocab_expression'].to_s
    @translation = info['vocab_meaning'].to_s
    @kana = info['vocab_kana'].to_s
    @romaji = kana.romaji
    @category = info['vocab_pos'].downcase.to_sym if info['vocab_pos']
    @jlpt_rating = info['jlpt'].to_s.scan(/\d+/).first.to_i
    @alphabet = contains_katakana? ? :katakana : :hiragana
    @expression_audio_path = info['vocab_sound_local']
  end

  def info
    ATTRIBUTES.to_h { |attribute| [attribute, public_send(attribute)] }
  end
end
