module Pomo
  class Task
    attr_reader :name
    attr_accessor :status
    
    def initialize(name)
      @name = name
      @status = :pending
      @type = :work
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
    
    def to_s
      if completed?
        "✓ #{@name}".colorize(:green)
      else
        "○ #{@name}".colorize(:yellow)
      end
    end
  end
end