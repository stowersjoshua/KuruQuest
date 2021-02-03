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

  # Example: search_by(:translation, 'lonely')
  #          search_by(:translation, /.one\w{2}/)
  def self.search_by(attribute, query)
    WORDS.select { |word| word.info[attribute].to_s.downcase.match? query }
  end
end
