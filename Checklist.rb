require 'json'

class Checklist
  def initialize(title, completed)
    @title = title
    @completed = completed
  end

  def to_json(options = nil)
    {title: @title, completed: @completed}.to_json
  end

  def toggle
    @completed = true unless @completed
  end

end
