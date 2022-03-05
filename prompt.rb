require 'terminal-table'

module Prompter
  def main_menu
    puts "create | show ID | update ID | delete ID | exit"
    print "> "
    action, id = gets.chomp.split
    [action, id]
  end

  def board_form
    print "Name: "
    name = gets.chomp
    print "Description: "
    description = gets.chomp
    { name: name, description: description }
  end

  def print_boards
    table = Terminal::Table.new
    table.title = "CLIn Boards"
    data = 
    table.headings = ['ID', 'Name', 'Description', 'List(#cards)']
    table.rows = @boards.map do |board|
      [board.id, board.name, board.description, (board.lists.map { |list| "#{list.name}(#{list.cards.size})"}).join(', ')]
    end
    puts table
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
