#!/usr/bin/env ruby

require_relative 'dictionary'
require_relative 'audio'
require 'optparse'
require 'colorize'

@help_count = 5
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

  parser.on '-f', '--flash-card-mode' do
    @flash_card_mode = true
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

def play_audio_file(filename)
  return unless File.exist?(filename)

  Audio.play(filename)
end

def give_help(gots, word)
  reveal_start, reveal_stop = case gots.split
                              in ['help', known_letters, unknown_letter_count]
                                reveal_start = known_letters.length
                                reveal_stop = reveal_start + unknown_letter_count.to_i.abs
                                [reveal_start, reveal_stop]
                              in ['help', unknown_letter_count]
                                reveal_start = 0
                                reveal_stop = reveal_start + unknown_letter_count.to_i.abs
                                [reveal_start, reveal_stop]
                              in ['help']
                                reveal_start = 0
                                reveal_stop = 1
                                [reveal_start, reveal_stop]
                              end

  hidden_characters = '_' * word.romaji.length
  revealed_characters = word.romaji[reveal_start...reveal_stop]
  hidden_characters[reveal_start...reveal_stop] = revealed_characters

  @help_count -= revealed_characters.length
  @help_count = 0 if @help_count.negative?

  puts hidden_characters.colorize(:blue)
end

def compile_word_list
  # Define category, set to nil if :any
  @category ||= prompt_for_category
  @category = nil if @category == :any

  # Define alphabet, set to nil if :any
  @alphabet ||= prompt_for_alphabet
  @alphabet = nil if @alphabet == :any

  # Find words with matching attributes, ignore nil filters
  word_filters = { category: @category, alphabet: @alphabet }.compact
  words = Dictionary.filter_by(**word_filters)

  words.shift(@skip_count)                # Skip words
  words = words.first(@limit) if @limit   # Limit word list size
  words.shuffle! if @shuffle              # Shuffle word list

  words
end

def start
  words = compile_word_list

  words.each.with_index(@skip_count.next) do |word, question_count|
    puts "Question #{question_count}:".colorize(:magenta)
    puts word.expression.colorize(:light_magenta) if @include_kanji && word.contains_kanji?
    puts "#{word.kana}\n".colorize(:light_magenta)

    play_audio_file("words/#{word.expression_audio_path}") if @verbose
    answer = gets.chomp.downcase

    if @flash_card_mode == true
      puts word.romaji.colorize(:light_blue)
      puts "Translation: #{word.translation}\n\n".colorize(:blue)
      `say "#{word.translation}"` if @verbose
      next
    else
      puts
    end

    if answer.start_with? 'help'
      give_help(answer, word) if @help_count.positive?
      puts "Helps remaining: #{@help_count}\n".colorize(:red)
      redo
    elsif answer == word.romaji
      puts "Correct!".colorize(:green)
      puts "Translation: #{word.translation}\n".colorize(:blue)
      `say "#{word.translation}"` if @verbose
    elsif @life_count.positive?
      puts "Incorrect!".colorize(:red)
      @life_count -= 1
      puts "Retries remaining: #{@life_count}\n".colorize(:red)
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
