# KuruQuest
A super simple CLI app for practicing Japanese kana.

Special thanks to `u/Nukemarine` for [sharing the dictionary.][dictionary_thread]

## Setup
The app requires Ruby 2.7.0 or later.

```bash
# Linux only
sudo dnf install sox # or ffmpeg 
sudo dnf install festival 

rvm use 2.7.0
bundle install
```

### Audio
#### Japanese
To hear the Japanese pronunciations, you will need to import the audio files from [here][word_audio_download] into the `./words/` directory.

Additionally, you will need either [play][sox_docs] from SoX or [ffplay][ffplay_docs] installed and in your PATH. 

#### English
Since Apple doesn't share their `say` program, Linux users will need to either download `festival`, or install [flite 2.2][flite_repo] from source. 

When using `flite`, it is assumed that you are using pule audio and have a [voice.flitevox][flite_voice_download] file in the project directory. This is still experimental, but much faster than `festival`.  

## Gameplay
### Running the Game
Start the game by running `/main.rb`.

You can toggle features and customize the word list by appending various flags:
* To specify a dictionary file: `-s --source dictionary.csv`
* To specify an alphabet: `-a --alphabet hiragana`
* To include kanji characters: `-k --show-kanji`
* To specify the category: `-c --category "noun"`
* To skip the first N words: `-s --skip 5`
* To limit the length of the word list: `-l --limit 5`
* To randomize the word order: `-r --shuffle`
* To disable answer checking: `-f --flash-card-mode`
* To hear the pronunciations and translations: `-v --verbose`

You can pass `any` to the `--alphabet` and `--category` flags to combine all options.

### Hints
You can type `help` instead of an answer to see the first letter of the solution.
```
Question 1:
ゲーム

> help

g____
```

You can also choose the number of letters you want revealed.

```
Question 1:
ゲーム

> help 3

gee__ 
``` 

If you already know the first few letters of the solution, include it just before the hint count.
Be aware that **the help feature will be disabled after the first 5 character reveals**. 

```
Question 1:
ゲーム

> help ge 3

__emu 
``` 

## Dictionaries
### Finding a word

Use `./bin/lookup` to search for words by their English translations.

You will be prompted for a query, which will be interpreted as a REGEX pattern.

Simply providing a generic string or substring for the word you want should still work as expected.

```bash
./bin/lookup 
Search: cure
  直す　 | なおす　　 | repair, cure, alter  
  治る　 | なおる　　 | be cured, get well   
  治す　 | なおす　　 | cure, heal           
  確実　 | かくじつ　 | certain, secure      
  確保　 | かくほ　　 | securement           
  厳重　 | げんじゅう | strict, secure       
  治まる | おさまる　 | settle down, be cured
```

## TODO
- [ ] Allow users to play without word filters
- [ ] Support usage of dot files for defining default settings

[dictionary_thread]: https://www.reddit.com/r/LearnJapanese/comments/s2iop/heres_a_spreadsheet_of_the_6000_most_common
[word_audio_download]: http://www.mediafire.com/file/oyddnozmbd2/kore-sound-vocab-munged.zip/file
[sox_docs]: http://sox.sourceforge.net/sox.html
[ffplay_docs]: https://ffmpeg.org/ffplay.html
[flite_repo]: https://github.com/festvox/flite
[flite_voice_download]: http://festvox.org/flite/packed/flite-2.1/voices/cmu_us_rms.flitevox
