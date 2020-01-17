require_relative 'dictionary'

def prompt_for_category
  puts 'Select a word category:'

  Dictionary::CATEGORIES.each.with_index(1) do |word, index|
    puts "#{index} - #{word}"
  end

  category_index = gets.chomp.to_i - 1
  Dictionary::CATEGORIES[category_index]
end

def start
  category = prompt_for_category

  words = Dictionary.filter_by(category: category, alphabet: :hiragana)

  words.each.with_index(1) do |word, question_count|
    puts "Question #{question_count}:"
    puts "#{word.expression}\n"

    answer = gets.chomp

    if answer == word.romaji
      puts "Correct!"
      puts "Translation: #{word.translation}\n\n"
    else
      puts "Incorrect!"
      puts "Answer: #{word.romaji}"
      puts "\nFinal score: #{question_count - 1}"
      return false
    end
  end
end

start
