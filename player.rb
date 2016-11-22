require_relative 'board'

class HumanPlayer
  attr_reader :color

  def initialize(name, display, color)
    @name = name
    @display = display
    @color = color
  end

  def play_turn
    positions = []

    loop do
      system("clear")
      @display.render(positions.first)
      puts "#{@name}, make a move."
      input = @display.cursor.get_input
      positions << input if input

      break if positions.length == 2
    end

    positions
  end

end


class ComputerPlayer
  attr_reader :color

  def initialize(name, display, color)
    @name = name
    @board = display.board
    @color = color
  end

  def select_piece
    piece_pos = @board.search(Piece, @color).sample
    return select_piece if @board[piece_pos].valid_moves.empty?
    piece_pos
  end

  def play_turn
    start_pos = select_piece
    p start_pos
    end_pos = @board[start_pos].valid_moves.sample

    [start_pos, end_pos]
  end
end
