module Pomo
  class Cycle
    PHASES = [
      { name: 'Pomodoro I', duration: 25, type: :work },
      { name: 'Short Rest', duration: 5, type: :break},
      { name: 'Pomodoro II', duration: 25, type: :work },
      { name: 'Long Rest', duration: 7, type: :break}
    ].freeze
    
    def initialize
      @current_phase = 0
      @pomo_count = 0
      @timer = nil
      @running = false
    end
    
    def start
      @running = true
      run_cycle
    end
    
    def stop
      @running = false
      @timer&.stop
      puts "\nCycle stopped."
    end
    
    def restart
      @current_phase = 0
      @timer&.restart
      puts "\nRestarting cycle..."
      start
    end
    
    private
    
    def run_cycle
      while @running
        phase = PHASES[@current_phase]
        
        puts "\n#{phase[:name]}(#{phase[:duration]} minutes)".colorize(:green)

        if phase[:type] == :work
          Sound.play_start_sound
        else
          Sound.play_break_sound
        end
        
        @timer = Timer.new(phase[:duration])
        @timer.start do
          if phase[:type] == :break
            2.times { Sound.play_break_sound }
          else
            Sound.play_end_sound
            @pomo_count += 1
            puts "| Pomodoros completed: #{@pomo_count}".colorize(:cyan)
          end
        end

        # Move to next phase
        @current_phase = (@current_phase + 1) % PHASES.length
      end
    end
  end
end