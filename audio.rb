class Audio
  class << self
    attr_accessor :processor

    def play(file_path)
      configure! unless configured?

      processor.play(file_path)
    end

    def configured?
      !processor.nil?
    end

    private

    def configure!
      if system 'which play &>-'
        self.processor = Play
      elsif system 'which ffplay &>-'
        self.processor = FFPlay
      else
        raise 'Unable to locate a supported audio processor'
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
end
