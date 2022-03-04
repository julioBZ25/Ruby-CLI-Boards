require_relative "board"
require 'json'

class Store 
  attr_reader :boards
  
  def initialize(filename)
    @filename = filename
    @boards = load_board
  end

  def load_board
    JSON.parse(File.read(@filename), symbolize_names: true).map do |board|
      Board.new(board)
    end
  end

  def append_board(board)
    @boards << board
    #File.write(@filename, @board.to_json)
  end

  def update_board(id, data)
    found_board = find_board(id)
    p found_board.update(data)
    # File.write(@filename, @board.to_json)
  end

  def find_board(id)
    @boards.find { |board| board.id == id.to_i }
  end
  
end

