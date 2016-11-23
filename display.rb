require 'colorize'
require_relative 'cursor'
require_relative 'board'
require 'byebug'

class Display
  attr_reader :cursor, :board

  def initialize(board)
    @board = board
    @cursor = Cursor.new([0, 0], board)
  end

  def render(selected_pos, show_moves=true, show_cursor=true)
    possible_moves = @board[selected_pos].moves if selected_pos

    header = "  "
    8.times { |x| header << " #{x} " }
    puts header

    @board.grid.each_with_index do |row, row_idx|
      print "#{row_idx} "
      row.each_with_index do |piece, col_idx|
        location = [row_idx, col_idx]
        if @cursor.cursor_pos == location && show_cursor
          print " #{piece.sym} ".colorize(background: :red)
        elsif selected_pos && selected_pos == location
          print " #{piece.sym} ".colorize(background: :light_red)
        elsif selected_pos && possible_moves.include?(location) && show_moves
          print " #{piece.sym} ".colorize(background: :light_red)
        elsif (row_idx + col_idx).even?
          print " #{piece.sym} "
        else
          print " #{piece.sym} ".colorize(background: :light_cyan)
        end
      end

      puts
    end

    nil
  end
end

if __FILE__ == $0
  p String.colors
end
