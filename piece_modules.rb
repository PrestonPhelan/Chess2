require 'byebug'

module SlidingPiece
  DIAG_MOVES = {
    up_right: [1, 1],
    up_left: [1, -1],
    down_right: [-1, 1],
    down_left: [-1, -1]
  }.freeze

  HORIZ_MOVES = {
    left: [0, -1],
    right: [0, 1],
    up: [-1, 0],
    down: [1, 0]
  }.freeze

  def moves
    possible_moves = []
    move_dirs.each do |_, v|
      i = 1

      loop do
        new_pos = [@pos[0] + v[0] * i, @pos[1] + v[1] * i]

        break unless @board.in_bounds?(new_pos)

        if @board[new_pos].color == other_color
          possible_moves << new_pos
          break
        elsif @board[new_pos] == @board.null_piece
          possible_moves << new_pos
          i += 1
        else
          break
        end
      end
    end

    possible_moves
  end

end

module SteppingPiece
  def moves
    possible_moves = []

    move_dirs.each do |v|
      new_pos = [@pos[0] + v[0], @pos[1] + v[1]]

      next unless @board.in_bounds?(new_pos)

      if @board[new_pos] == @board.null_piece ||
        @board[new_pos].color == other_color

        possible_moves << new_pos
      end
    end

    possible_moves
  end
end
