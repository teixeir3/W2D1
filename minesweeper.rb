require './board.rb'

class BoardNode
  attr_accessor :position, :mark, :adjacents

  def initialize(mark = nil)
    @position = nil
    @mark = mark
    @adjacents = nil
  end

  def to_s
    if @mark
      @mark
    else
      "_"
    end
  end

end

class Minesweeper

  BOMBS = 10

  MARKS = {
    # two for clicked
    'bomb' => :B,
    'safe' => :D, # GET IT???
    # two for unclicked
    'blank' => :_, # is this even necessary?
    'flag' => :F,
  }
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
    make_bombs


  end

  def is_bomb?(pos)
    @board[pos] == :B ? true : false
  end

  def place_mark(pos, mark)
    if @board.empty?(pos)
      @board[pos] = mark
      true
    else
      false
    end
  end

  def board_setup
    # pick number of bombs
    # this can be random, or based on difficulty, or whatever
    # we'll start with ten, the beginner setting
    # expert would be 64
    (0..8).each do |row|
      (0..8).each do |col|
        @board[[row, col]] = BoardNode.new
      end
    end
    make_bombs
    nil
  end

  def make_bombs
    bombs_placed = 0
    until bombs_placed == BOMBS
      rand_node_position = [rand(9), rand(9)]

      if @board[rand_node_position].mark.nil?
        @board[rand_node_position].mark = :B
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