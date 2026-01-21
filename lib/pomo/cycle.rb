module Pomo
  class Cycle
    WORK_DURATION = 25
    SHORT_BREAK = 5
    LONG_BREAK = 15
    POMODOROS_BEFORE_LONG_BREAK = 4
    
    def initialize
      @task_list = TaskList.new
      @current_task = nil
      @pomo_count = 0
      @timer = nil
      @running = false
    end
    
    def start(chosen_task = nil)
      @running = true
      @current_task = chosen_task ? @task_list.all[chosen_task] : fetch_next_task
      
      unless @current_task
        puts "\nNo pending tasks. Add tasks first with 'pomo add <task_name>'".colorize(:yellow)
        return
      end
      
      run_cycle
    end
    
    def stop
      @running = false
      @timer&.stop
      puts "\nCycle stopped."
    end
    
    private
    
    def run_cycle
      while @running
        # Check if we still have tasks to work on
        unless @current_task
          puts "\n✓ All tasks completed! There are no more pomodoros.".colorize(:green)
          stop
          break
        end
        
        # Run Pomodoro with current task
        run_pomodoro
        break unless @running
        
        # Ask if task is complete
        if task_completed?
          @current_task.complete!
          @task_list.save_tasks
          puts "✓ Task marked as complete!".colorize(:green)
          @current_task = fetch_next_task
        else
          puts "→ Continuing with same task".colorize(:yellow)
        end
        
        # Check again if we have more tasks
        unless @current_task
          puts "\n✓ All tasks completed! There are no more pomodoros.".colorize(:green)
          stop
          break
        end
        
        # Run break
        run_break
      end
    end
    
    def run_pomodoro
      @pomo_count += 1
      puts "\nPomodoro #{@pomo_count}: ".colorize(:green) + 
          "#{@current_task.name}".colorize(:cyan) + 
          " (#{WORK_DURATION} min)".colorize(:green)      
      Sound.play_start_sound
      @timer = Timer.new(WORK_DURATION, :work)
      @timer.start do
        Sound.play_end_sound
      end
    end
    
    def run_break
      break_type = (@pomo_count % POMODOROS_BEFORE_LONG_BREAK == 0) ? :long : :short
      duration = (break_type == :long) ? LONG_BREAK : SHORT_BREAK
      break_name = (break_type == :long) ? "Long Break" : "Short Break"
      
      puts "#{break_name} (#{duration} min)".colorize(:magenta)
      
      Sound.play_break_sound
      @timer = Timer.new(duration, :break)
      @timer.start do
        2.times { Sound.play_break_sound }
      end
    end
    
    def task_completed?
      print "\nTask completed? (Y/n): "
      response = $stdin.gets.chomp.downcase
      response == 'y' || response == 'yes' || response.empty?
    end
    
    def fetch_next_task
      @task_list.pending_tasks.first
    end
  end
end