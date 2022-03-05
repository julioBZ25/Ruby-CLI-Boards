require_relative "card"

class List
  attr_reader :cards, :name, :id
  @@id_sequence = 0
  
  def initialize(list)
    set_id(list[:id])
    @name = list[:name]
    @cards =  list[:cards].nil? ? [] : list[:cards].map { |card| Card.new(card) } 
  end

  def load_cards
    JSON.parse(File.read(@filename), symbolize_names: true)
  end

  def update(data)
    @name = data unless data.empty?
  end

  def set_id(id)
    if id.nil?
      @id = (@@id_sequence+= 1)
    elsif
      @id = id
      @@id_sequence = id if id > @@id_sequence
    end
  end
end