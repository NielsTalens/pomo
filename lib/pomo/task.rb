module Pomo
  class Task
    attr_reader :name
    attr_accessor :status, :pomo_count

    def initialize(name, pomo_count = 0)
      @name = name
      @status = :pending
      @type = :work
      @pomo_count = pomo_count.to_i
    end
    
    def complete!
      @status = :completed
    end
    
    def pending!
      @status = :pending
    end

    def pending?
      @status == :pending
    end
    
    def completed?
      @status == :completed
    end

    def increment_pomo!
      @pomo_count += 1
    end
    
    def to_s
      count_label = " | #{@pomo_count}"
      if completed?
        "✓ #{@name}#{count_label}".colorize(:green)
      else
        "○ #{@name}#{count_label}".colorize(:yellow)
      end
    end
  end
end
