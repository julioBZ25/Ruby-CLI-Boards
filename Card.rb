require 'json'
require_relative "Checklist"

class Card
  @@id_sequence = 0
  
  def initialize(title:, members:, labels:, due_date:, checklist: [], id: nil)
    set(id)
    @title = title
    @members = members
    @labels = labels
    @due_date = due_date
    @checklist = checklist.map { |task| Checklist.new(task)}
    
  end

  def to_json(options = nil)
    {title: @title, completed: @completed}.to_json
  end

  def to_json(options = nil)
    {id: @id, name: @name, members: @members, labels: @labels, due_date: @due_date, checklist: @checklist}.to_json
  end

  def set_id(id)
    if id.nil?
      @id = (@@id_sequence+= 1)
    elsif
      @id = id
      @@id_sequence = id if id > @@id_sequence
    end
  end

end