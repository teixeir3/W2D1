# specifically for the Minesweeper game
class Board
  attr_reader :rows
  attr_accessor :uncovered_spaces, :bombs

  def self.blank_grid
    Array.new(9) { Array.new(9) }
  end

  def initialize(rows = self.class.blank_grid)
    @rows = rows
    @uncovered_spaces = 0
    @bombs = 0
  end

  def show
    # not very pretty printing!
    self.rows.each { |row| p row }
  end

  def [](pos)
    x, y = pos[0], pos[1]
    @rows[x][y]
  end

  def []=(pos, node)

    x, y = pos[0], pos[1]
    @rows[x][y] = node
  end

  def dup
    duped_rows = rows.map(&:dup)
    self.class.new(duped_rows)
  end

  def empty?(pos)
    self[pos].nil?
  end

  def is_on_board?(pos)
    x,y = pos[0], pos[1]
    if x < 0 || x > 8 || y < 0 || y > 8
      false
    else
      true
    end
  end

  def won?
    ### won when:
    # no of uncovered spaces == board size - no of bombs
    # and
    # revealed all non-bomb spaces
    # flags are dealt with upon win
    @uncovered_spaces >= (81 - @bombs) ? true : false #changed == to >=
  end

end