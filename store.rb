require_relative "board"
require 'json'

class Store 
  attr_reader :boards
  
  def initialize(filename)
    @filename = filename
    @boards = load_board
  end

  def load_board
    JSON.parse(File.read(@filename), symbolize_names: true).map { |board| Board.new(board) }
  end

  def remove_board(id) 
    @boards.select! { |board| board.id != id.to_i }
    # File.write(@filename, @playlists.to_json)
  end

  def append_board(board)
    @boards << board
    #File.write(@filename, @board.to_json)
  end

  def append_list(board, list)
    board.lists << list
    # File.write(@filename, @playlists.to_json)
  end
  
  def append_list(board, list)
    board.lists << list
    # File.write(@filename, @playlists.to_json)
  end

  def append_card(found_board, card_data, card)
    found_list = find_list(found_board, card_data[:list])
    found_list.cards << card
    # File.write(@filename, @playlists.to_json)
  end

  def update_board(id, data)
    found_board = find_board(id)
    found_board.update(data)
    # File.write(@filename, @board.to_json)
  end

  def update_list(list, id, data)
    found_list = find_list(list, id)
    found_list.update(data)
    # File.write(@filename, @board.to_json)
  end

  def find_board(id)
    @boards.find { |board| board.id == id.to_i }
  end

  def find_list(list, id)
    list.lists.find { |list| list.name == id }
  end
  
end

