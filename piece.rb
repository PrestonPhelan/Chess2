require_relative 'board'
require 'singleton'
require_relative 'piece_modules'

class Piece
  attr_reader :sym
  attr_accessor :pos

  def initialize(pos, board, color = :white)
    @sym = "p"
    @pos = pos
    @board = board
    @color = color
  end

  def moves

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
    [@pos[0] + move_dirs[0], @pos[1] + move_dirs[1]]
  end
end
