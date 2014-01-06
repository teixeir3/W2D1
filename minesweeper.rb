require './board.rb'

class BoardNode
  attr_accessor :mark, :adjacents, :flagged, :bomb, :revealed
  attr_reader :children_with_bombs

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

  def initialize(board, pos)
    @pos = pos
    @adjacents = nil
    @board = board

    #these get changed with user input
    @flagged = false
    @revealed = false

    #these get changed in game-setup
    @bomb = false
    @children_with_bombs = 0

  end

  def children_with_bombs
    bombs = 0
    self.children.each do |child|
      if child.bomb
        bombs += 1
      end
    end
    @children_with_bombs = bombs
  end

  def children
    # returns an array of the positions of all adjacent cells
    x,y = @pos[0], @pos[1]
    children = []

    # check each position
    ADJACENTS.each do |pos_calc|
       new_x = x + pos_calc[0]
       new_y = y + pos_calc[1]
       if @board.is_on_board?([new_x, new_y])
        children << @board[[new_x, new_y]]
      end
    end
    # if it's on the board, add it

    children
  end

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



  attr_accessor :board, :bomb_splosion

  def initialize
    @board = Board.new # take this out after testing
    @bomb_splosion = false

  end

  def play
    # put new board init here when starting to play
    board_setup

    # Take turn until game is over
    until game_over?

      take_turn

    end
    # uncover everything


  end

  def game_over?
    bomb_splosion || won
  end

  def take_turn
    puts "Please enter a position, human. ([x,y])"
    position = []
    gets.chomp.scan(/\d/).each do |d|
      position << d.to_i
    end
    current_node = @board[position]
    puts "What do you want to do at this position?"
    puts "1 - uncover, 2 - flag"

    move = gets.chomp.to_i
    case move
    when 1 # uncover
      p current_node.bomb
      if current_node.bomb
        @bomb_splosion = true
        puts "It's a bomb!"
      else
        current_node.revealed = true

        current_node.children.each do |child|
          unless child.bomb
            child.revealed = true
          end
        end
      end

        # check children for bombs
        # display number
        # queue = current_node.children
        # until queue.empty?# it runs out of children w/o bombs
        #   p queue
        #   child = queue.shift
        #
        #   if child.bomb
        #     next
        #   else
        #     child.revealed = true # should happen in to_s it, display #children_with_bombs
        #   end

          # queue.concat(child.children)

    when 2 # flag
      # mark a flag
      @flags += 1
      @board[position].flag = true
    end

  end

  def board_setup
    # pick number of bombs
    # this can be random, or based on difficulty, or whatever
    # we'll start with ten, the beginner setting
    # expert would be 64
    (0..8).each do |row|
      (0..8).each do |col|
        @board[[row, col]] = BoardNode.new(@board, [row, col])
      end
    end
    make_bombs
    update_bomb_counts
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

  def update_bomb_counts
    (0..8).each do |row|
      (0..8).each do |col|
        @board[[row, col]].children_with_bombs
      end
    end
    nil
  end


  def reveal
    # if not bomb, then we reveal
    # BFS of all adjacent cells - searches adj cells and children
    #
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