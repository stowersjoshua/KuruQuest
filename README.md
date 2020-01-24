# KuruQuest
A super simple CLI app for practicing Japanese kana.

Special thanks to `u/Nukemarine` for [sharing the dictionary.][dictionary_thread]

## Setup
The app requires Ruby 2.7.0 or later.

```bash
brew install libsndfile portaudio
bundle install
```
**Note:**
To hear the Japanese pronunciations, you will need to import the audio files from [here][word_audio_download] into the `./words/` directory and [convert them to .wav files.][mp3_conversion_example]

## Gameplay
Start the game by `/main.rb`.

You can toggle features and customize the word list by appending various flags:
* To specify an alphabet: `-a --alphabet hiragana`
* To include kanji characters: `-k --show-kanji`
* To specify the category: `-c --category "noun"`
* To skip the first N words: `-s --skip 5`
* To limit the length of the word list: `-l --limit 5`
* To randomize the word order: `-r --shuffle`
* To hear the pronunciations and translations: `-v --verbose`

## TODO
- [ ] Allow users to play without word filters

[dictionary_thread]: https://www.reddit.com/r/LearnJapanese/comments/s2iop/heres_a_spreadsheet_of_the_6000_most_common
[word_audio_download]: http://www.mediafire.com/file/oyddnozmbd2/kore-sound-vocab-munged.zip/file
[mp3_conversion_example]: https://stackoverflow.com/a/52338741
