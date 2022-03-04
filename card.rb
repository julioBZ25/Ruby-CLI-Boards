require 'json'
require_relative "checklist"

class Card
  attr_reader :title, :members, :labels, :due_date, :checklist, :id
  @@id_sequence = 0
  
  def initialize(card)
    #set(id)
    @id = card[:id]
    @title = card[:title]
    @members = card[:members]
    @labels = card[:labels]
    @due_date = card[:due_date]
    @checklist = card[:checklists].nil? ? [] : card[:checklists].map { |task| Checklist.new(task)}
    
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