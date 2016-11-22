
module SlidingPiece
  DIAG_MOVES = {
    up_right: [1, 1],
    up_left: [1, -1],
    down_right: [-1, 1],
    down_left: [-1, -1]
  }

  HORIZ_MOVES = {
    left: [0, -1],
    right: [0, 1],
    up: [-1, 0],
    down: [1, 0]
  }

  def moves
    possible_moves = []

    move_dirs.each do |_, v|

      i = 1

      loop do
        new_pos = [@pos[0] + v[0] * i, @pos[1] + v[1] * i]
        # if board[new_pos] == opposing_piece
        # => add to possible_moves
        # => break

        if @board.in_bounds?(new_pos) && @board[new_pos] == @board.null_piece
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
      if @board.in_bounds?(new_pos) && @board[new_pos] == @board.null_piece
        possible_moves << new_pos
      end
    end

    possible_moves
  end
end
