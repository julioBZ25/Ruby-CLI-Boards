require 'json'

class Checklist
  attr_reader :title, :completed
  
  def initialize(task)
    @title = task[:title]
    @completed = task[:completed]
  end

  def to_json(options = nil)
    {title: @title, completed: @completed}.to_json
  end

  def toggle
    @completed = true unless @completed
  end

end
