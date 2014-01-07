require './board.rb'
require 'debugger'
require 'yaml'

class BoardNode
  attr_accessor :mark, :adjacents, :flagged, :bomb, :revealed
  attr_reader :children_with_bombs, :pos

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

  def generate_child_bomb_count
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
  # TO DO: make alternate displays / render for user and testers.

  attr_accessor :board, :bomb_splosion

  def initialize(bombs, save_game = nil)
    load_game(save_game)if save_game

    # could add load file here somehow
    @bombs = bombs # had new board and bomb_splosion
    @board = Board.new
    @bomb_splosion = false
  end

  def play

    setup

    # Take turn until game is over
    until game_over?

      take_turn
      @board.show
      p @board.uncovered_spaces

    end
    # uncover everything
    puts "Game over!"
    @board.show

  end

  def save_game(file)
    File.open(file,"w") do |f|
      f.puts @board.to_yaml
    end
  end

  def load_game(file)
    yaml_board = File.read(file)
    @board = YAML::load(yaml_board)
  end

  def game_over?
    bomb_splosion || @board.won?
  end

  def reveal_from(current_node)
    #debugger
    current_node.revealed = true
    #   current_node.children.each do |child|
    #     if child.bomb
    #       next
    #     elsif child.children_with_bombs > 0
    #       child.revealed = true
    #     elsif child.children_with_bombs == 0
    #       reveal_from(child)
    #     else
    #       puts "something else happened."
    #     end
    #   end
    queue = [current_node]
    queue.concat(current_node.children)
    visited_nodes = []

    until queue.empty?
      next_node = queue.shift
      visited_nodes << next_node
      if next_node.bomb
        next
      elsif next_node.children_with_bombs > 0
        next_node.revealed = true
        @board.uncovered_spaces += 1
      else
        next_node.revealed = true
        @board.uncovered_spaces += 1
        queue.concat(next_node.children - visited_nodes)
      end
    end
    nil
  end

  def take_turn
    puts "Please enter a position ([x,y])"
    puts "or 's' to save."
    if gets.chomp == "s"
      puts "enter save game name"
      name = gets.chomp
      save_game(name)
    else
      position = []
      gets.chomp.scan(/\d/).each do |d|
        position << d.to_i
        position = position.reverse
      end
      current_node = @board[position]
      puts "What do you want to do at this position?"
      puts "1 - uncover, 2 - flag"

      move = gets.chomp.to_i
      case move
      when 1 # uncover
        if current_node.bomb
          @bomb_splosion = true
          puts "It's a bomb!"
        else
          reveal_from(current_node)
        end


      when 2 # flag
        # mark a flag
        @flags += 1
        @board[position].flagged = true

      end
    end

  end

  def setup
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
    until bombs_placed == @bombs
      rand_node_position = [rand(9), rand(9)]

      if @board[rand_node_position].bomb == false
        @board[rand_node_position].bomb = true
        bombs_placed +=1
        @board.bombs +=1
      end
    end
    nil
  end

  def update_bomb_counts
    (0..8).each do |row|
      (0..8).each do |col|
        @board[[row, col]].generate_child_bomb_count
      end
    end
    nil
  end
  #
  # #we are going to re-write this
  # def bfs(pos, &prc)
  #   bombs_count = 0
  #   children = children(pos)
  #   until children.empty?
  #     child = children.shift
  #
  #     if is_bomb?(child)
  #       return node if node.value == target
  #     else
  #       return node if prc.call(node)
  #     end
  #
  #     children.concat(children(child))
  #   end
  #   nil
  # end

  def list_bombs
    list = []
    (0..8).each do |row|
      (0..8).each do |col|
       list << [row, col] if @board[[row, col]].bomb
      end
    end
    list
  end

end