module Colors
  COLORS = ["yellow", "white", "black", "brown", "orange", "red", "green", "blue"]
end

class Game
  include Colors

  @@human_wins = 0
  @@computer_wins = 0

  attr_accessor :game_board, :code_breaker
  attr_reader :code_setter

  def initialize
    @game_board = GameBoard.new
    puts "Set code?"
    if gets.chomp == "y"
      @code_setter = CodeSetter.new(true)
      @code_breaker = CodeBreaker.new(false)
    else
      @code_setter = CodeSetter.new(false)
      @code_breaker = CodeBreaker.new(true)
    end
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

  def check_color_and_position (code, guess)
    guess.each_with_index.reduce(0) do |correct, (color, i)|
      code[i] == color ? correct += 1 : correct
    end
  end

  def check_win
    code_setter.code == code_breaker.player_choice ? true : false
  end

  def display_board ()
    p COLORS
    puts "\n"
    for i in 0..11
      p game_board.decoding_board[i]
      p game_board.feedback_board[i]
      puts "\n"
    end
  end

  def get_guess
    gets.chomp.split(" ")
  end

  def take_turn
    puts "Guess four colors:"
    code_breaker.player_choice = get_guess
    game_board.decoding_board[code_breaker.turn_number] = code_breaker.player_choice
    game_board.feedback_board[code_breaker.turn_number][:colors_correct] = check_color(code_setter.code, code_breaker.player_choice)
    game_board.feedback_board[code_breaker.turn_number][:color_and_position_correct] = check_color_and_position(code_setter.code, code_breaker.player_choice)
    code_breaker.turn_number += 1
    display_board
    puts "------------------"
  end

  def play_game
    while code_breaker.turn_number < 12
      take_turn
      if check_win
        puts "Congratulations! You won in #{code_breaker.turn_number} tries."
        code_breaker.turn_number = 12
      elsif code_breaker.turn_number == 12
        puts "You lost. The code was #{code_setter.code}"
      end
    end
  end
end

class Player
  include Colors

  attr_reader :human
  attr_accessor :turn_number

  def initialize (human)
    @player_choice = []
    @human = human
    if self == self.human && @human == true
      puts "Input your code:"
      @code = gets.chomp.split(" ")
    else
      @code = COLORS.sample(4)
    end
  end
end

module Computer
  def random_code (color_array)
    color_array.sample(4)
  end
end

module Human
  attr_accessor :player_choice

  def initialize (human)
    super (human)
  end
end

class CodeBreaker
  include Computer, Human

  def initialize (human)
    @human = human
    @turn_number = 0
    @player_choice = []
  end
end

class CodeSetter
  include Computer, Human, Colors

  def initialize (human)
    @human = human
    if @human == true
      puts "Input your code:"
      @code = gets.chomp.split(" ")
      p @code
    else
      @code = random_code(COLORS)
      p @code
    end
  end
end

class GameBoard
  attr_accessor :decoding_board, :feedback_board

  def initialize
    @decoding_board = Array.new(12) { Array.new(4, "_") }
    @feedback_board = Array.new(12) { Hash.new }
  end
end

game = Game.new