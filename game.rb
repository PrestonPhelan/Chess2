require_relative 'player'
require_relative 'board'

class Game

  def initialize(name1, name2)
    @board = Board.new
    @display = Display.new(@board)

    @player1 = HumanPlayer.new(name1, @display, :white)
    @player2 = HumanPlayer.new(name2, @display, :black)
    @current_player = @player1
  end

  def play
    until game_over?
      begin
        positions = @current_player.play_turn

        raise unless @board[positions[0]].color == @current_player.color

        @board.move_piece(positions[0], positions[1])

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
    @board.checkmate?(:white) || @board.checkmate?(:black)
  end

  def switch_players!
    @current_player = (@current_player == @player1 ? @player2 : @player1)
  end

end

if __FILE__ == $0
  Game.new("1", "2").play
end
