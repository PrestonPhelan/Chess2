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

  def get_piece_locations
    @display.board.search(Piece, @color)
  end

  ## Get their moves
  def get_all_moves
    all_piece_locations = get_piece_locations
    moves = Hash.new { [] }

    all_piece_locations.each do |start_pos|
      @display.board[start_pos].valid_moves.each do |end_pos|
        moves[start_pos] += [end_pos]
      end
    end

    moves
  end

end


class ComputerPlayer
  attr_reader :color

  def initialize(name, display, color)
    @name = name
    @board = display.board
    @color = color
  end

  ## Get all your pieces
  def get_piece_locations
    @board.search(Piece, @color)
  end

  ## Get their moves
  def get_all_moves
    all_piece_locations = get_piece_locations
    moves = Hash.new { [] }

    all_piece_locations.each do |start_pos|
      @board[start_pos].valid_moves.each do |end_pos|
        moves[start_pos] += [end_pos]
      end
    end

    moves
  end
  ## Check their moves for capturing

  def get_captures
    captures = Hash.new

    get_all_moves.each do |k, v|
      captures[k] = v.select do |end_pos|
        @board[end_pos].other_color == @color
      end
    end

    captures.reject { |_, v| v.empty? }
  end

  ## Select those moves and sample

  def select_piece
    piece_pos = get_piece_locations.sample
    return select_piece if @board[piece_pos].valid_moves.empty?
    piece_pos
  end

  def select_move
    captures = get_captures
    #debugger
    if captures.empty?
      start_pos = select_piece
      end_pos = @board[start_pos].valid_moves.sample
      [start_pos, end_pos]
    else
      start_pos = captures.keys.sample
      end_pos = captures[start_pos].sample
      [start_pos, end_pos]
    end
  end

  def play_turn
    select_move
  end
end
