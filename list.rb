require_relative "card"

class List
  attr_reader :cards, :name
  
  def initialize(list)
    @id = list[:id]
    @name = list[:name]
    @cards =  list[:cards].nil? ? [] : list[:cards].map { |card| Card.new(card) } 
  end
  def load_cards
    JSON.parse(File.read(@filename), symbolize_names: true)
  end
end