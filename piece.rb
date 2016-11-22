require_relative 'board'
require 'singleton'
require 'byebug'
require_relative 'piece_modules'

class Piece
  attr_reader :sym, :color
  attr_accessor :pos

  def initialize(pos, board, color = :white)
    @sym = "p"
    @pos = pos
    @board = board
    @color = color
  end

  def to_s
    "#{@sym} at #{@pos}"
  end

  def inspect
    to_s
  end


  def moves

  end

  def other_color
    @color == :white ? :black : :white
  end

  def move_into_check?(end_pos)
    ## Duplicate the board
    new_board = @board.dup

    ##Perform the move
    new_board.move_piece(@pos, end_pos)

    ##See if player is in check
    new_board.in_check?(@color)
  end

  def valid_moves
    self.moves.reject { |pos| self.move_into_check?(pos) }
  end
end

class NullPiece < Piece
  include Singleton

  def initialize
    @sym = " "
  end
end

class Bishop < Piece
  include SlidingPiece

  def initialize(pos, board, color)
    super
    @sym = @color == :white ? "\u2657".encode('utf-8') : "\u265D".encode('utf-8')
  end

  def move_dirs
    SlidingPiece::DIAG_MOVES
  end
end

class Rook < Piece
  include SlidingPiece

  def initialize(pos, board, color)
    super
    @sym = @color == :white ? "\u2656".encode('utf-8') : "\u265C".encode('utf-8')
  end

  def move_dirs
    SlidingPiece::HORIZ_MOVES
  end

end

class Queen < Piece
  include SlidingPiece

  def initialize(pos, board, color)
    super
    @sym = @color == :white ? "\u2655".encode('utf-8') : "\u265B".encode('utf-8')
  end

  def move_dirs
    SlidingPiece::HORIZ_MOVES.merge(SlidingPiece::DIAG_MOVES)
  end
end

class Knight < Piece
  include SteppingPiece

  def initialize(pos, board, color)
    super
    @sym = @color == :white ? "\u2658".encode('utf-8') : "\u265E".encode('utf-8')
  end

  def move_dirs
    [ [1, 2],
      [-1, 2],
      [-1, -2],
      [1, -2],
      [2, 1],
      [2, -1],
      [-2, 1],
      [-2, -1]]
  end
end

class King < Piece
  include SteppingPiece

  def initialize(pos, board, color)
    super
    @sym = @color == :white ? "\u2654".encode('utf-8') : "\u265A".encode('utf-8')
  end

  def move_dirs
    [
      [1, 0],  [1, 1],   [1, -1],
      [0, 1],            [0, -1],
      [-1, 0], [-1, -1], [-1, 1]
    ]
  end

end


class Pawn < Piece
  def initialize(pos, board, color)
    super
    @sym = @color == :white ? "\u2659".encode('utf-8') : "\u265F".encode('utf-8')
  end

  def move_dirs
    @color == :white ? [1, 0] : [-1, 0]
  end

  def moves
    arr = [[@pos[0] + move_dirs[0], @pos[1] + move_dirs[1]]]
    side_attacks.each { |attack| arr << attack }
    arr
  end

  def side_attacks
    direction = move_dirs.first
    check_pos = [[@pos[0] + direction, @pos[1]-1], [@pos[0] + direction, @pos[1]+1]]
    #debugger
    check_pos.select do |pos|
      @board.in_bounds?(pos) && @board[pos].color == other_color
    end
  end
end
