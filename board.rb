require_relative 'piece'
require_relative 'display'
require 'byebug'

class Board
  attr_reader :grid, :null_piece

  def initialize(grid = default_grid)
    @grid = grid
    @null_piece = NullPiece.instance
    populate if grid == default_grid
  end

  def default_grid
    Array.new(8) { Array.new }
  end

  def set_grid(grid)
    @grid = grid
  end

  def populate
    @grid[0] = back_row(:white)
    @grid[1] = pawn_row(:white)

    2.upto(5) { |idx| 8.times { @grid[idx] << @null_piece } }

    @grid[6] = pawn_row(:black)
    @grid[7] = back_row(:black)
  end

  def back_row(color)
    row = []
    row_idx = color == :white ? 0 : 7

    row << Rook.new([row_idx, 0], self, color)
    row << Knight.new([row_idx, 1], self, color)
    row << Bishop.new([row_idx, 2], self, color)
    row << Queen.new([row_idx, 3], self, color)
    row << King.new([row_idx, 4], self, color)
    row << Bishop.new([row_idx, 5], self, color)
    row << Knight.new([row_idx, 6], self, color)
    row << Rook.new([row_idx, 7], self, color)

    row
  end

  def pawn_row(color)
    row = []
    row_idx = color == :white ? 1 : 6
    0.upto(7) { |i| row << Pawn.new([row_idx, i], self, color) }
    row
  end

  def move_piece(start_pos, end_pos)
    raise if self[start_pos] == @null_piece || !in_bounds?(end_pos)
    self[end_pos] = self[start_pos]
    self[end_pos].pos = end_pos
    self[start_pos] = @null_piece
  rescue
    puts "Invalid position."
  end

  def in_bounds?(pos)
    pos.all? { |coord| coord >= 0 && coord <= 7 }
  end

  def in_check?(color)
    king_pos = search(King, color).first
    opposing_pieces = search(Piece, color == :white ? :black : :white)

    opposing_pieces.any? do |piece|
      self[piece].moves.include?(king_pos)
    end
  end

  def checkmate?(color)
    return false unless in_check?(color)
    own_pieces = search(Piece, color)
    own_pieces.all? do |piece|
      self[piece].valid_moves.empty?
    end
  end

  def search(piece_type, color)
    found_pos = []

    @grid.each_with_index do |row, row_idx|
      row.each_with_index do |piece, col_idx|
        if piece.is_a?(piece_type) && piece.color == color
          found_pos << [row_idx, col_idx]
        end
      end
    end

    found_pos
  end

  def dup
    b = Board.new

    duped_grid = @grid.map do |row|
      row.map do |piece|
        if piece.is_a?(NullPiece)
          @null_piece
        else
          piece.class.new(piece.pos, b, piece.color)
        end
      end
    end

    # update board w/ new grid
    b.set_grid(duped_grid)
    b
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, mark)
    row, col = pos
    @grid[row][col] = mark
  end
end

if __FILE__ == $0
  b = Board.new
  d = Display.new(b)

  # d.render
  # b.move_piece([6, 5], [5, 5])
  # b.move_piece([1, 4], [3, 4])
  # b.move_piece([6, 6], [4, 6])
  # b.move_piece([0, 3], [4, 7])
  # d.render
  # p b.checkmate?(:black)
  # p b.in_check?(:black)
end
