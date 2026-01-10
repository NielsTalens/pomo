module Pomo
  class Timer
    attr_reader :duration, :remaining
    
    def initialize(minutes, type = :work)
      @duration = (minutes * 60) # Convert to seconds
      @remaining = @duration
      @running = false
      @type = type
    end
    
    def start(&on_complete)
      @running = true
      @start_time = Time.now
      
      while @running && @remaining > 0
        sleep(1)
        @remaining = @duration - (Time.now - @start_time).to_i
        print_time
      end
      
      @running = false
      on_complete.call if on_complete && @remaining <= 0
    end
    
    def stop
      @running = false
    end
    
    def restart
      @remaining = @duration
      @running = false
    end
    
    private
    
    def print_time
      minutes = @remaining.to_i / 60
      seconds = @remaining.to_i % 60
      
      # Calculate progress
      progress = 1.0 - (@remaining.to_f / @duration)
      bar_width = 30
      filled = (bar_width * progress).to_i
      empty = bar_width - filled
      
      # Build progress bar with colors based on type
      if @type == :work
        filled_bar = ('█' * filled).green
      else  # :break
        filled_bar = ('█' * filled).magenta
      end
      empty_bar = ('░' * empty).light_black
      percentage = "#{(progress * 100).to_i}%".cyan
      time = "#{minutes}:#{seconds.to_s.rjust(2, '0')}".yellow
      
      print "\r#{filled_bar}#{empty_bar} #{percentage} | #{time} "
      $stdout.flush
    end
  end
end