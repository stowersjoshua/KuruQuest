#!/usr/bin/env ruby

require_relative 'dictionary'
require 'optparse'

OptionParser.new do |parser|
  parser.on '-c', '--category [CATEGORY]' do |category|
    puts "Category: #{category}\n"
    @category = category.to_sym
  end
end.parse!

def prompt_for_category
  puts 'Select a word category:'

  Dictionary::CATEGORIES.each.with_index(1) do |word, index|
    puts "#{index} - #{word}"
  end

  category_index = gets.chomp.to_i - 1
  @category = Dictionary::CATEGORIES[category_index]
end

def start
  prompt_for_category if @category.nil?

  words = Dictionary.filter_by(category: @category, alphabet: :hiragana)

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
