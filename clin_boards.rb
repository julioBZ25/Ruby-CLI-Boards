require_relative "store"
require 'terminal-table'
require_relative "prompt" # enlazas el archivo prompt con tu archivo actual

class ClinBoards
  attr_reader :store, :boards

  include Prompter # llamar a modulo

  def initialize(filename = "store.json")
    # Complete this
    @store = Store.new(filename)
    @boards = @store.boards
  end

  def start
    # Complete this
    # prompt welcome 
    # prompt Tabla - Clin Boards
    print_boards

    action, id = menu (:board)
    until action == "exit"
      case action
      when "create" then create_board
      when "show" then puts "show ID"
      when "update" then update_board(id)
      when "delete" then puts "delete ID"
      end
      print_boards
    action, id = menu (:board)
    end
  end

  def create_board
    board_data = board_form
    board = Board.new(board_data) # => { id: id, name: name, description: description, lists: [] }
    @store.append_board(board)
  end

  def update_board(id)
    board_data = board_form
    # board = Board.new(board_data) # => { id: id, name: name, description: description, lists: [] }
    @store.update_board(id, board_data)
  end

  def board_form
    puts "Name: "
    name = gets.chomp
    puts "Description: "
    description = gets.chomp
    {name: name, description: description}
  end
end

# get the command-line arguments if neccesary
app = ClinBoards.new
app.start
