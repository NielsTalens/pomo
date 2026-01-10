module Pomo
  class Sound
    SOUNDS_DIR = File.expand_path('../../sounds', __dir__)
    
    def self.play_start_sound
      play_sound('start.wav')
    end
    
    def self.play_end_sound
      play_sound('end.wav')
    end

    # Letś see if the looping break sound is a nice feature or a one shot is better
    def self.play_break_sound
      play_sound('MF_Harmonics-B.wav')
    end
    
    def self.start_looping_break_sound
      @stop_loop = false
      @loop_thread = Thread.new do
        while !@stop_loop
          play_sound('MF_Harmonics-B.wav')
        end
      end
    end
    
    def self.stop_looping_break_sound
      @stop_loop = true
      @loop_thread&.join
    end
    
    private
    
    def self.play_sound(filename)
      sound_path = File.join(SOUNDS_DIR, filename)
      
      unless File.exist?(sound_path)
        puts "Sound file not found: #{sound_path}"
        puts "\a"  # Terminal bell as fallback
        return
      end
      
      if command_exists?('paplay')
        system("paplay #{sound_path}")
      elsif command_exists?('aplay')
        system("aplay #{sound_path}")
      elsif command_exists?('ffplay')
        system("ffplay -nodisp -autoexit #{sound_path} 2>/dev/null")
      else
        puts "No audio player found. Install paplay, aplay, or ffplay."
        puts "\a"
      end
    end
    
    def self.command_exists?(cmd)
      system("which #{cmd} > /dev/null 2>&1")
    end
  end
end