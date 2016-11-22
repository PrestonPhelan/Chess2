class HumanPlayer
  attr_reader :color

  def initialize(name, display, color)
    @name = name
    @display = display
    @color = color
  end

  def play_turn
    positions = []

    loop do
      system("clear")
      @display.render
      puts "#{@name}, make a move."
      input = @display.cursor.get_input
      positions << input if input

      break if positions.length == 2
    end

    positions
  end

end
