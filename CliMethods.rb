
require_relative "store"
require_relative "board"

class ClinMethods
  def initialize(filename = "store.json")
    @store = Store.new(filename)
    @boards = @store.boards
  end

  # Metodos para Board
  def board_form
    print "Name: "
    name = gets.chomp
    print "Description: "
    description = gets.chomp
    { name: name, description: description }
  end
end
