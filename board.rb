require_relative 'piece'
require_relative 'display'

class Board
  attr_reader :grid, :null_piece

  def initialize
    @grid = Array.new(8) { Array.new }
    @null_piece = NullPiece.instance
    populate
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
  d.render
  # d.display_loop
  b.move_piece([6, 3], [4, 3])
  b.move_piece([1, 4], [3, 4])
  b.move_piece([0, 1], [2, 2])
  d.render
  p b[[2, 2]].moves


end
