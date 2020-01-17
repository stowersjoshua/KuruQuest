require 'csv'
require 'mojinizer'

def dictionary
  CSV.read('dictionary.csv', headers: true)
end

def word_categories
  return @categories unless @categories.nil?

  categories = dictionary.map { |row| row['Vocab-pos'] }.uniq
  @categories = categories.sort
end

def words_by_category
  return @categorized_words unless @categorized_words.nil?

  @categorized_words = dictionary.each.with_object({}) do |row, categorized_words|
    categorized_words[row['Vocab-pos']] ||= []
    categorized_words[row['Vocab-pos']] << row['Vocab-kana']
  end
end

def translate_by_kana(kana)
  word_data = dictionary.detect { |row| row['Vocab-kana'] == kana }
  word_data['Vocab-meaning']
end

def prompt_for_category
  puts 'Select a word category:'

  word_categories.each.with_index(1) do |word, index|
    puts "#{index} - #{word}"
  end

  category_index = gets.chomp.to_i - 1
  word_categories[category_index]
end

def start
  category = prompt_for_category

  words_by_category[category].each.with_index(1) do |word, question_count|
    next unless word.hiragana? # This needs to be filtered beforehand since it messes with question_count

    puts "Question #{question_count}:"
    puts "#{word}\n"

    answer = gets.chomp

    if answer == word.romaji
      puts "Correct!"
      puts "Translation: #{translate_by_kana(word)}\n\n"
    else
      puts "Incorrect!"
      puts "Answer: #{word.romaji}"
      puts "\nFinal score: #{question_count - 1}"
      return false
    end
  end
end

start
