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
    File.write(@filename, @boards.to_json)
  end

  def append_board(board)
    @boards << board
    File.write(@filename, @boards.to_json)
  end

  def append_list(board, list)
    board.lists << list
    File.write(@filename, @boards.to_json)
  end

  def append_card(found_board, card_data, card)
    found_list = find_list(found_board, card_data[:list])
    found_list.cards << card
    File.write(@filename, @boards.to_json)
  end

  def append_task(card, task)
    card.checklist << task
    File.write(@filename, @boards.to_json)
  end

  def update_board(id, data)
    found_board = find_board(id)
    found_board.update(data)
    File.write(@filename, @boards.to_json)
  end

  def update_list(list, id, data)
    found_list = find_list(list, id)
    found_list.update(data)
    File.write(@filename, @boards.to_json)
  end

  def update_card(list, id, data)
    found_card = find_card(list, id)
    found_card.update(data)
    list.lists.each do |list|
      list.cards.reject! { |card| card.id == id.to_i }
      list.push_card(found_card) if list.name == data[:list]
    end
    File.write(@filename, @boards.to_json)
  end

  def update_checklist(found_card, id)
    found_card.checklist[(id.to_i) - 1].toggle
    File.write(@filename, @boards.to_json)
  end

  def find_board(id)
    @boards.find { |board| board.id == id.to_i }
  end

  def find_list(list, id)
    list.lists.find { |list| list.name == id }
  end

  def find_card(list,id)
    card = list.lists.map { |list| list.cards.find { |card| card.id == id.to_i } }
    return card[0]
  end

  def remove_list(list, id)
    list.lists.delete_if { |list| list.name == id }
    File.write(@filename, @boards.to_json)
  end

  def remove_card(list, id)
    list.lists.each {  |list| list.cards.delete_if { |card| card.id == id.to_i   } }
    File.write(@filename, @boards.to_json)
  end

  def remove_task(card, id)
    card.checklist.delete_at(id.to_i - 1)
    File.write(@filename, @boards.to_json)
  end
end

