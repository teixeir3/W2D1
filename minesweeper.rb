require './board.rb'

class BoardNode
  attr_accessor :mark, :adjacents, :flagged, :bomb
  attr_reader :children_with_bombs

  def initialize(board, pos)
    @position = pos
    @adjacents = nil
    @board = board

    #these get changed with user input
    @flagged = false
    @revealed = false

    #these get changed in game-setup
    @bomb = false
    @children_with_bombs = 0


    #fix game setup
  end

  # visual aspects of a node:
  # => number display (including 0, which is blank and clicked?)
  # => flag
  # => unclicked
  #
  # bomb or not


  def to_s
    # this is where rendering happens
    if @revealed
      @children_with_bombs
    elsif @flagged
      :F
    else
      "_"
    end
  end

end

class Minesweeper

  BOMBS = 10

  # TO DO: make alternate displays / render for user and testers.
  ADJACENTS = [
    # clockwise order
    [-1, -1],
    [0, -1],
    [1, -1],
    [1, 0],
    [1, 1],
    [0, 1],
    [-1, 1],
    [-1, 0]
    ]


  attr_accessor :board

  def initialize
    @board = Board.new # take this out after testing


  end

  def play
    # put new board init here when starting to play
    board_setup

    # Take turn until game is over
    until game_over?

      take_turn

    end


  end

  def game_over?
    won || bomb_splosion
  end

  def take_turn
    puts "Please enter a position, human. ([x,y])"
    position = gets.chomp.to_a

    puts "What do you want to do at this position?"
    puts "1 - uncover, 2 - flag"

    move = gets.chomp.to_i

    case move
    when 1 # uncover
      # what's there?
      # if  bomb, die
      # => and display board
      if @board[position] == :B
      end
      # if not, reveal, and reveal children until children have bombs
      # => in which case, show number
      # if on node, display # of children with bombs
      # blank == no children with bombs

    when 2 # flag
      # mark a flag
      @flags += 1
      @board[position].flag = true
    end

  end

  def is_bomb?(pos)
    @board[pos].mark == :B ? true : false
  end

  def set_mark(pos, mark)
    @board[pos].mark = mark
  end

  def board_setup
    # pick number of bombs
    # this can be random, or based on difficulty, or whatever
    # we'll start with ten, the beginner setting
    # expert would be 64
    (0..8).each do |row|
      (0..8).each do |col|
        @board[[row, col]] = BoardNode.new(@board, [[row, col]])
      end
    end
    make_bombs
    nil
  end

  def make_bombs
    bombs_placed = 0
    until bombs_placed == BOMBS
      rand_node_position = [rand(9), rand(9)]

      if @board[rand_node_position].bomb == false
        @board[rand_node_position].bomb = true
        bombs_placed +=1
      end
    end
    nil
  end



  def reveal
    # if not bomb, then we reveal
    # BFS of all adjacent cells - searches adj cells and children
    #
  end

  def children(start_pos)
    # returns an array of the positions of all adjacent cells
    x,y = start_pos[0], start_pos[1]
    children = []

    # check each position
    ADJACENTS.each do |pos_calc|
      unless x + pos_calc[0] < 0 || y + pos_calc[1] < 0
        children << [x + pos_calc[0], y + pos_calc[1]]
      end
    end
    # if it's on the board, add it

    children
  end

  #we are going to re-write this
  def bfs(pos, &prc)
    bombs_count = 0
    children = children(pos)
    until children.empty?
      child = children.shift

      if is_bomb?(child)
        return node if node.value == target
      else
        return node if prc.call(node)
      end

      children.concat(children(child))
    end
    nil
  end


end