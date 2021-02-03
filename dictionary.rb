require_relative 'word'
require 'csv'

class Dictionary
  word_info = CSV.read('dictionary.csv', headers: true).map(&:to_h)

  WORDS = word_info.map { |info| Word.new(**info) }.freeze
  CATEGORIES = WORDS.map(&:category).uniq.sort.freeze

  # Example: search(alphabet: :katakana)
  def self.search(**attribute_filters)
    WORDS.select { |word| attribute_filters <= word.info }
  end
end
