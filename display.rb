require 'colorize'
require_relative 'cursor'
require_relative 'board'
require 'byebug'

class Display
  attr_reader :cursor

  def initialize(board)
    @board = board
    @cursor = Cursor.new([0, 0], board)
  end

  def render
    header = "  "
    8.times { |x| header << " #{x} " }
    puts header

    @board.grid.each_with_index do |row, row_idx|
      print "#{row_idx} "
      row.each_with_index do |piece, col_idx|
        if @cursor.cursor_pos == [row_idx, col_idx]
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
  # p String.colors
end
