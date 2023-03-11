module Colors
  COLORS = ["yellow", "white", "black", "brown", "orange", "red", "green", "blue"]
end

class Game
  include Colors

  @@human_wins = 0
  @@computer_wins = 0

  def initialize
    @decoding_board = Array.new(12) { Array.new(4, "_") }
    @computer_code = Computer.new
  end

  def display_board ()
    p COLORS
    @decoding_board.each do |row| 
      p row
      puts "\n"
    end
  end
end

class Computer
  include Colors

  def initialize
    @code = COLORS.sample(4)
  end
end

class Human
  include Colors

  def initialize
    @player_choice = Array.new(4)
  end
end

game = Game.new
game.display_board