require 'mojinizer'
require 'forwardable'

# Note: Kanji gets sorted into the :hiragana library

class Word
  extend Forwardable

  ATTRIBUTES = %i(expression translation kana romaji category jlpt_rating alphabet expression_audio_path)
  attr_accessor *ATTRIBUTES

  def_delegators :expression, :hiragana?, :katakana?, :kanji?, :contains_kanji?, :contains_hiragana?, :contains_katakana?

  def initialize(**info)
    @kana = extract_info(info, keys: ['vocab_kana', 'kana'])
    @translation = extract_info(info, keys: ['vocab_meaning', 'translation'])
    @expression = extract_info(info, keys: ['vocab_expression', 'expression'])
    @jlpt_rating = extract_info(info, keys: ['jlpt', 'jlpt_rating']).scan(/\d+/).first.to_i
    @category = extract_info(info, keys: ['vocab_pos', 'category'], default: 'unknown').downcase.to_sym
    @expression_audio_path = extract_info(info, keys: ['vocab_sound_local', 'expression_audio_path'])
    @alphabet = contains_katakana? ? :katakana : :hiragana
    @romaji = kana.romaji
  end

  def info
    ATTRIBUTES.to_h { |attribute| [attribute, public_send(attribute)] }
  end

  private

  def extract_info(info, keys:, default: nil)
    value = info.values_at(*keys).compact.last
    value || default || value.to_s
  end
end
