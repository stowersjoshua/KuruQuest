#!/usr/bin/env ruby

require_relative 'dictionary'
require 'optparse'
require 'colorize'

@life_count = 5
@skip_count = 0

OptionParser.new do |parser|
  parser.on '-a', '--alphabet [ALPHABET]' do |alphabet|
    @alphabet = alphabet.to_sym
  end

  parser.on '-k', '--show-kanji' do
    @include_kanji = true
  end

  parser.on '-c', '--category [CATEGORY]' do |category|
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
  puts 'Select a word category:'.colorize(:blue)

  Dictionary::CATEGORIES.each.with_index(1) do |word, index|
    puts "#{index} - #{word}".colorize(:light_blue)
  end

  category_index = gets.chomp.to_i - 1
  puts
  Dictionary::CATEGORIES[category_index]
end

def prompt_for_alphabet
  puts '[H]iragana or [K]atakana?'.colorize(:blue)

  response = gets.chomp.downcase
  puts
  response == 'k' ? :katakana : :hiragana
end

def start
  @category ||= prompt_for_category
  @alphabet ||= prompt_for_alphabet

  words = Dictionary.filter_by(category: @category, alphabet: @alphabet)
  words.shift(@skip_count)
  words = words.first(@limit) if @limit
  words.shuffle! if @shuffle

  words.each.with_index(@skip_count.next) do |word, question_count|
    puts "Question #{question_count}:".colorize(:magenta)
    puts word.expression.colorize(:light_magenta) if @include_kanji && word.contains_kanji?
    puts "#{word.kana}\n".colorize(:light_magenta)

    answer = gets.chomp
    puts

    if answer == word.romaji
      puts "Correct!".colorize(:green)
      puts "Translation: #{word.translation}\n".colorize(:blue)
      `say "#{word.translation}"` if @verbose
    elsif @life_count.positive?
      puts "Incorrect!".colorize(:red)
      @life_count -= 1
      puts "Retries remaining: #{@life_count}".colorize(:red)
      redo
    else
      puts "Incorrect!".colorize(:red)
      puts "Answer: #{word.romaji}".colorize(:blue)
      puts "\nFinal score: #{question_count - 1}".colorize(:green)
      return false
    end
  end

  puts 'Congratulations! List complete!'.colorize(:green)

rescue SystemExit, Interrupt
  puts "\n\nさよなら".colorize(:yellow)
end

start
