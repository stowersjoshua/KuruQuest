class Audio
  class << self
    attr_accessor :play_processor

    def play(file_path)
      configure_play_processor!

      play_processor.play(file_path)
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
end
