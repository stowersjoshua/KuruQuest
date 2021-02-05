require_relative 'word'
require 'csv'

class Dictionary
  DEFAULT_SOURCE_PATH = 'dictionary.csv'.freeze
  attr_accessor :source_path, :words, :categories

  def initialize(source_path = DEFAULT_SOURCE_PATH)
    @source_path = source_path

    word_info = CSV.read(source_path, headers: true).map(&:to_h)
    @words = word_info.map { |info| Word.new(**info) }.freeze
    @categories = words.map(&:category).uniq.sort.freeze
  end

  # Example: search(alphabet: :katakana)
  def search(**attribute_filters)
    words.select { |word| attribute_filters <= word.info }
  end

  # Example: search_by(:translation, 'lonely')
  #          search_by(:translation, /.one\w{2}/)
  def search_by(attribute, query)
    words.select { |word| word.info[attribute].to_s.downcase.match? query }
  end
end
