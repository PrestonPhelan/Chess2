class Game

  def initialize(player1, player2)
    @board = Board.new
    @player1 = player1
    @player2 = player2
    @current_player = @player1
  end

  def play
    until game_over?
      @current_player.play_turn
      switch_players!
    end
  end

  def game_over?
    @board.checkmate?(:white) || @board.checkmate?(:black)
  end

  def switch_players!
    @current_player = (@current_player == @player1 ? @player2 : @player1)
  end

end
