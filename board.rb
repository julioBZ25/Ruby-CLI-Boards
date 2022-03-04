require_relative "list"
require 'json'

class Board
  attr_reader :name, :description, :lists, :id

  def initialize(board)
    @id = board[:id]
    @name = board[:name]
    @description = board[:description]
    @lists = board[:lists].nil? ? [] : board[:lists].map { |lists| List.new(lists)}
  end
  
  def to_json(options = nil)
    {id: @id, name: @name, description: @description, lists: @lists}.to_json
  end

  def update(data)
    @name = data[:name] unless data[:name].empty?
    @description = data[:description] unless data[:description].empty?
  end
end

