require 'terminal-table'

module Prompter
  def print_boards
    table = Terminal::Table.new
    table.title = "CLIn Boards"
    data = ""
    table.headings = ["ID", "Name", "Description", "List(#cards)"]
    table.rows = @boards.map do |board|
    [board.id, board.name, board.description, (board.lists.map { |list| "#{list.name}(#{list.cards.size} )" } ).join(", ")]
    end
    puts table
  end

  def print_lists(found_board)
    title = found_board.lists.map { |list| list.name }
    headings = ["ID", "Title", "Members", "Labels", "Due Date", "Checklist"]
    rows = found_board.lists.map { |list| list.cards.map { |card| [card.id, card.title, card.members.join(", "), card.labels.join(", "), card.due_date, task(card.checklist)] } }
    p rows
    (0...title.length).each { |i| print_list(title[i], headings, rows[i]) }
  end

  def task(checklist)
    i = 0
    checklist.each { |task| i += 1 if task.completed }
    return "#{i} / #{checklist.size}"
  end
  
  def print_list(title, headings, rows)
    table = Terminal::Table.new
    table.title = title
    table.headings = headings
    table.rows = rows
    puts table
  end

  def print_checklist(found_card)
    puts "Card: #{found_card.title}"
    task = found_card.checklist.map { |task| [task.title, task.completed] }
    (0...found_card.checklist.size).each do |i|
      print task[i][1] ? "[x] " : "[ ] "
      puts "#{i + 1}. #{task[i][0]}"
    end
  end

  def menu(opcion)
    option = { board: ["create", "show ID", "update ID", "delete ID", "exit"],
    list: ["create-list", "update-list LISTNAME", "delete-list LISTNAME"],
    cards: ["create-card", "checklist ID", "update-card ID", "delete-card ID", "back"],
    checklist: ["add", "toggle INDEX", "delete INDEX"] }
    case opcion
    when :list
      puts "List options: #{option[:list][0]} | #{option[:list][1]} | #{option[:list][2]}"
      puts "Card options: #{option[:cards][0]} | #{option[:cards][1]} | #{option[:cards][2]} | #{option[:cards][3]} | #{option[:cards][4]}"
      print "> "
    when :board
      puts "#{opcion.to_s} option: #{option[opcion][0]} | #{option[opcion][1]} | #{option[opcion][2]} | #{option[opcion][3]} | #{option[opcion][4]}"
      print "> "
    when :checklist
      puts "#{opcion.to_s} option: #{option[opcion][0]} | #{option[opcion][1]} | #{option[opcion][2]} "
      print "> "
    end
    gets.chomp.split
  end
end
