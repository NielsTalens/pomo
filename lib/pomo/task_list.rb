require 'json'

module Pomo
  class TaskList
    def initialize(file_path = File.expand_path('~/.pomo_tasks.json'))
      @file_path = file_path
      @tasks = load_tasks
    end
    
    def add(name)
      task = Task.new(name)
      @tasks << task
      save_tasks
      task
    end
    
    def delete(index)
      @tasks.delete_at(index)
      save_tasks
    end

    def complete(index)
      @tasks[index]&.complete!
      save_tasks
    end

    def reset(index)
      @tasks[index]&.pending!
      save_tasks
    end
    
    def list
      @tasks.each_with_index do |task, index|
        puts "#{index + 1}. #{task}"
      end
    end
    
    def pending_tasks
      @tasks.select(&:pending?)
    end
    
    def all
      @tasks
    end

    def move_up(index)
      return if index <= 0
      @tasks[index], @tasks[index - 1] = @tasks[index - 1], @tasks[index]
      save_tasks
    end

    def move_down(index)
      return if index >= @tasks.length - 1
      @tasks[index], @tasks[index + 1] = @tasks[index + 1], @tasks[index]
      save_tasks
    end

    def save_tasks
      File.write(@file_path, JSON.pretty_generate(@tasks.map { |t| { name: t.name, status: t.status } }))
    end
    private
    
    def load_tasks
      return [] unless File.exist?(@file_path)
      JSON.parse(File.read(@file_path)).map do |data|
        Task.new(data['name']).tap { |t| t.status = data['status'].to_sym }
      end
    rescue JSON::ParserError
      []
    end
    
  end
end