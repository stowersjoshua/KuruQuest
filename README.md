# KuruQuest
A super simple CLI app for practicing Japanese kana.

Special thanks to `u/Nukemarine` for [sharing the dictionary.][dictionary_thread]

## Usage
The app requires Ruby 2.7.0 or later.

```bash
bundle install

bundle exec ruby main.rb
# or
./main.rb -c 'adjectival noun'
```
You can filter the word list by running the app with various flags:
* To specify an alphabet: `-a --alphabet hiragana`
* To include kanji characters: `-k --show-kanji`
* To specify the category: `-c --category "noun"`
* To skip the first N words: `-s --skip 5`
* To limit the length of the word list: `-l --limit 5`
* To randomize the word order: `-r --shuffle`
* To read the translation out loud: `-v --verbose`

## TODO
- [ ] Allow users to play without word filters

[dictionary_thread]: https://www.reddit.com/r/LearnJapanese/comments/s2iop/heres_a_spreadsheet_of_the_6000_most_common
