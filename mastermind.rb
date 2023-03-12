module Colors
  COLORS = ["yellow", "white", "black", "brown", "orange", "red", "green", "blue"]
end

class Game
  include Colors

  @@human_wins = 0
  @@computer_wins = 0

  attr_accessor :game_board, :player
  attr_reader :computer

  def initialize
    @game_board = GameBoard.new
    @computer = Computer.new
    @player = Human.new
    p @computer
  end

  def check_color (code, guess, code_for_mod=[])
    code.each { |element| code_for_mod << element }
    guess.reduce(0) do |correct, color|
      if code_for_mod.any?(color)
        code_for_mod.delete(color)
        correct += 1
      else
        correct
      end
    end
  end

  def check_win
    computer.code == player.player_choice ? true : false
  end

  def display_board ()
    p COLORS
    for i in 0..11
      p game_board.decoding_board[i]
      puts game_board.feedback_board[i]
      puts "\n"
    end
  end

  def get_guess
    gets.chomp.split(" ")
  end

  def take_turn
    player.player_choice = get_guess
    game_board.decoding_board[player.turn_number] = player.player_choice
    p check_color(computer.code, player.player_choice)
    p computer.code
    player.turn_number += 1
    display_board
  end
end

class Computer
  include Colors

  attr_reader :code

  def initialize
    @code = COLORS.sample(4)
  end
end

class Human
  include Colors

  attr_accessor :player_choice, :turn_number

  def initialize
    @player_choice = []
    @turn_number = 0
  end
end

class GameBoard
  attr_accessor :decoding_board, :feedback_board

  def initialize
    @decoding_board = Array.new(12) { Array.new(4, "_") }
    @feedback_board = Array.new(12, "")
  end
end

game = Game.new
game.take_turn