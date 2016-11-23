require_relative 'player'
require_relative 'board'

class Game

  def initialize(name1 = "White", name2 = "Black")
    @board = Board.new
    @display = Display.new(@board)

    @player1 = ComputerPlayer.new(name1, @display, :white)
    @player2 = ComputerPlayer.new(name2, @display, :black)
    @current_player = @player1
  end

  def play
    until game_over?
      begin
        #debugger

        positions = @current_player.play_turn

        raise unless @board[positions[0]].color == @current_player.color

        @board.move_piece(positions[0], positions[1])
        @board.check_pawn_promotion

        system("clear")
        @display.render(positions[1], false, false)
        sleep 0.25

        switch_players!

      rescue ArgumentError
        puts "You can't make that move."
        sleep 1
        retry
      rescue
        puts "That's not your piece!!!!"
        sleep 1
        retry
      end
    end
  end

  def game_over?
    if @board.checkmate?(:white) || @board.checkmate?(:black)
      winner = @board.checkmate?(:white) ? :black : :white
      puts "Checkmate!  #{winner.capitalize} wins."
      return true
    end

    pieces_pos = @board.search(Piece, @current_player.color)
    if pieces_pos.all? { |location| @board[location].valid_moves.empty? }
      puts "No more valid moves!  It's a stalemate."
      return true
    end

    false
  end

  def switch_players!
    @current_player = (@current_player == @player1 ? @player2 : @player1)
  end

end

if __FILE__ == $0
  Game.new.play
end
