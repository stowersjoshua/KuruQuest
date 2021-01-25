class Audio
  class << self
    attr_accessor :play_processor, :say_processor

    def play(file_path)
      configure_play_processor!

      play_processor.play(file_path)
    end

    def say(verbiage)
      configure_say_processor!

      say_processor.say(verbiage)
    end

    private

    def configure_play_processor!
      return if play_processor

      if system 'which play &>-'
        self.play_processor = Play
      elsif system 'which ffplay &>-'
        self.play_processor = FFPlay
      else
        raise 'Unable to locate a supported audio processor'
      end
    end

    def configure_say_processor!
      return if say_processor

      if system 'which padsp &>- && which flite &>-'
        self.say_processor = Flite
      elsif system 'which say &>-'
        self.say_processor = Say
      elsif system 'which festival &>-'
        self.say_processor = Festival
      else
        raise 'Unable to locate a supported text to speech processor'
      end
    end
  end

  class Processor; end

  class Play < Processor
    def self.play(file_path)
      system("play #{file_path} --no-show-progress")
    end
  end

  class FFPlay < Processor
    def self.play(file_path)
      system("ffplay #{file_path} -nodisp -loglevel 0 -autoexit")
    end
  end

  class Say < Processor
    def self.say(verbiage)
      system("say #{verbiage}")
    end
  end

  class Festival < Processor
    def self.say(verbiage)
      verbiage.delete!('()')
      system("echo #{verbiage} | festival --tts")
    end
  end

  class Flite < Processor
    def self.say(verbiage)
      system("padsp flite -voice voice.flitevox -t '#{verbiage}'")
    end
  end
end
