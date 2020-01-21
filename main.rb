#!/usr/bin/env ruby

require_relative 'dictionary'
require 'optparse'

@life_count = 5
@skip_count = 0

OptionParser.new do |parser|
  parser.on '-k', '--show-kanji' do
    @include_kanji = true
  end

  parser.on '-c', '--category [CATEGORY]' do |category|
    puts "Category: #{category}\n\n"
    @category = category.to_sym
  end

  parser.on '-s', '--skip [SKIP N]', Integer do |skip_count|
    @skip_count = skip_count
  end

  parser.on '-l', '--limit [LIMIT]', Integer do |limit|
    @limit = limit
  end

  parser.on '-r', '--shuffle' do
    @shuffle = true
  end

  parser.on '-v', '--verbose' do
    @verbose = true
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
  words.shift(@skip_count)
  words = words.first(@limit) if @limit
  words.shuffle! if @shuffle

  words.each.with_index(@skip_count.next) do |word, question_count|
    puts "Question #{question_count}:"
    puts word.expression if @include_kanji && word.contains_kanji?
    puts "#{word.kana}\n"

    answer = gets.chomp

    if answer == word.romaji
      puts "Correct!"
      puts "Translation: #{word.translation}\n\n"
      `say "#{word.translation}"` if @verbose
    elsif @life_count.positive?
      puts "Incorrect!"
      @life_count -= 1
      puts "Retries remaining: #{@life_count}\n\n"
      redo
    else
      puts "Incorrect!"
      puts "Answer: #{word.romaji}"
      puts "\nFinal score: #{question_count - 1}"
      return false
    end
  end

  puts "\nCongratulations! List complete!"
end

start
