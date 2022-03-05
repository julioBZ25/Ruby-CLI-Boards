require_relative "store"
require 'terminal-table'
require_relative "prompt" # enlazas el archivo prompt con tu archivo actual

class ClinBoards
  attr_reader :store, :boards

  include Prompter # llamar a modulo

  def initialize(filename = "store.json")
    # Complete this
    @store = Store.new(filename) # ins de la clase store ---- 
    @boards = @store.boards # [obj board, obj board, ....]
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
      when "show" then show_list(id)
      when "update" then update_board(id)
      when "delete" then delete_board(id)
      end

      print_boards
    action, id = menu (:board)
    end
  end

  def show_list(id)
    found_board = @store.find_board(id)
    print_lists(found_board)
    action, id = menu(:list)
    until action == "back"
      case action
      when "create-list" then create_list(found_board)
      when "update-list" then update_list(found_board, id)
      when "delete-list" then puts "delete lista"
      when "create-card" then create_card(found_board)
      when "checklist" then puts "show checklist"
      when "update-card" then puts "update card"
      when "delete-card" then puts "delete card"
      else
        puts "Invalid option!"
      end
      print_lists(found_board)
      action, id = menu(:list)
    end
  end

  def delete_board(id)
    @store.remove_board(id)
  end

  def create_board
    board_data = forms("board")
    board = Board.new(board_data) # => { id: id, name: name, description: description, lists: [] }
    @store.append_board(board)
  end

  def create_list(found_board)
    list_data = forms("list")
    list = List.new(list_data) # => { id: id, name: name, description: description, lists: [] }
    @store.append_list(found_board, list)
  end

  def create_card(found_board)
    card_data = forms("card", found_board)
    card = Card.new(card_data)
    p @store.append_card(found_board, card_data, card)
  end

  def update_board(id)
    board_data = forms("board")
    #board = Board.new(board_data) # => { id: id, name: name, description: description, lists: [] }
    @store.update_board(id, board_data)
  end

  def update_list(found_board, id)
    list_data = forms("list")
    #list = Board.new(list_data) # => { id: id, name: name, description: description, lists: [] }
    @store.update_list(found_board, id, list_data)
  end

  def forms(option, found_board = "")
    case option
    when "board"
      print "Name: "
      name = gets.chomp
      print "Description: " 
      description = gets.chomp
      return {name: name, description: description}
    when "list"
      print "Name: "
      name = gets.chomp
      return{name: name}
    when "card"
      puts "Select a list: "
      puts (found_board.lists.map { |list| "#{list.name}" }).join(' | ')
      print "> "
      list = gets.chomp
      print "Title: "
      title = gets.chomp
      print "Members: "
      members = gets.chomp.delete(' ')
      p members
      print "Labels: "
      labels = gets.chomp
      print "due_date: "
      due_date = gets.chomp
      return {list: list, title: title, members: members, labels: labels, due_date: due_date}
    end
  end

  def menu(opcion)
    option = {board: ["create", "show ID", "update ID", "delete ID", "exit"],
    list: ["create-list", "update-list LISTNAME", "delete-list LISTNAME"],         
    cards: ["create-card", "checklist ID", "update-card ID", "delete-card ID", "back"],
    checklist: ["add", "toggle INDEX", "delete INDEX"]
    }
    case opcion
    when :list
      puts "List options: #{option[:list][0]} | #{option[:list][1]} | #{option[:list][2]}"
      puts "Card options: #{option[:cards][0]} | #{option[:cards][1]} | #{option[:cards][2]} | #{option[:cards][3]} | #{option[:cards][4]}"
      print "> "
    when :board
      puts "#{opcion.to_s} option: #{option[opcion][0]} | #{option[opcion][1]} | #{option[opcion][2]} | #{option[opcion][3]} | #{option[opcion][4]} "
      print "> "
    when :checklist
      puts "#{opcion.to_s} option: #{option[opcion][0]} | #{option[opcion][1]} | #{option[opcion][2]} "
      print "> "
    end
    gets.chomp.split
  end

end

# get the command-line arguments if neccesary
app = ClinBoards.new
app.start
