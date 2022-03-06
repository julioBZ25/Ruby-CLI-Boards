require_relative "store"
require "terminal-table"
require_relative "prompt"

class ClinBoards
  attr_reader :store, :boards
  include Prompter

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
      when "delete-list" then delete_list(found_board, id)
      when "create-card" then create_card(found_board)
      when "checklist" then puts show_checklist(found_board, id)
      when "update-card" then update_card(found_board, id)
      when "delete-card" then puts delete_card(found_board, id)
      else
        puts "Invalid option!"
      end
      print_lists(found_board)
      action, id = menu(:list)
    end
  end

  def show_checklist(found_board, id)
    found_card = @store.find_card(found_board, id)
    print_checklist(found_card)
    action, id = menu(:checklist)
    until action == "back"
      case action
      when "add" then add_checklist(found_card)
      when "toggle" then toggle_checklist(found_card, id)
      when "delete" then delete_checklist(found_card, id)
      else
        puts "Invalid option!"
      end
      print_checklist(found_card)
      action, id = menu(:checklist)
    end
  end

  def delete_checklist(found_card, id)
    @store.remove_task(found_card, id)
  end

  def toggle_checklist(found_card, id)
    @store.update_checklist(found_card, id)
  end

  def add_checklist(found_card)
    data = forms("checklist")
    task = Checklist.new(data)
    @store.append_task(found_card, task)
  end

  def delete_board(id)
    @store.remove_board(id)
  end

  def delete_list(found_board, id)
    @store.remove_list(found_board, id)
  end

  def delete_card(found_board, id)
    @store.remove_card(found_board, id)
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
    @store.append_card(found_board, card_data, card)
  end

  def update_board(id)
    board_data = forms("board")
    @store.update_board(id, board_data)
  end

  def update_list(found_board, id)
    list_data = forms("list")
    @store.update_list(found_board, id, list_data)
  end

  def update_card(found_board, id)
    card_data = forms("card", found_board)
    #card = Board.new(list_data) # => { id: id, name: name, description: description, lists: [] }
    @store.update_card(found_board, id, card_data)
  end

  def forms(option, found_board = "")
    case option
    when "board"
      print "Name: "
      name = gets.chomp
      print "Description: "
      description = gets.chomp
      return { name: name, description: description }
    when "list"
      print "Name: "
      name = gets.chomp
      return { name: name }
    when "card"
      puts "Select a list: "
      puts (found_board.lists.map { |list| list.name }).join(" | ")
      print "> "
      list = gets.chomp
      print "title: "
      title = gets.chomp
      print "Members: "
      members = gets.chomp.delete(" ").split
      print "Labels: "
      labels = gets.chomp.delete(" ").split
      print "due_date: "
      due_date = gets.chomp
      return { list: list, title: title, members: members, labels: labels, due_date: due_date }
    when "checklist"
      print "Title: "
      title = gets.chomp
      return { title: title }
    end
  end

  def menu(opcion)
    option = { board: ["create", "show ID", "update ID", "delete ID", "exit"],
    list: ["create-list", "update-list LISTNAME", "delete-list LISTNAME"],
    cards: ["create-card", "checklist ID", "update-card ID", "delete-card ID", "back"],
    checklist: ["add", "toggle INDEX", "delete INDEX", "back"]
    }
    case opcion
    when :list
      puts "List options: #{option[:list][0]} | #{option[:list][1]} | #{option[:list][2]}"
      puts "Card options: #{option[:cards][0]} | #{option[:cards][1]} | #{option[:cards][2]} | #{option[:cards][3]} | #{option[:cards][4]}"
      print " > "
      action, list, name = gets.chomp.split
      return action, name.nil? ? "#{list}" : "#{list} #{name}"
    when :board
      puts "#{opcion.to_s} option: #{option[opcion][0]} | #{option[opcion][1]} | #{option[opcion][2]} | #{option[opcion][3]} | #{option[opcion][4]} "
      print "> "
    when :checklist
      puts "#{opcion.to_s} option: #{option[opcion][0]} | #{option[opcion][1]} | #{option[opcion][2]} | #{option[opcion][3]} "
      print "> "
    end
    gets.chomp.split
  end
end

# get the command-line arguments if neccesary
app = ClinBoards.new
app.start
