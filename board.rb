# specifically for the Minesweeper game
class Board
  attr_reader :rows

  def self.blank_grid
    Array.new(9) { Array.new(9) }
  end

  def initialize(rows = self.class.blank_grid)
    @rows = rows
    @flags = 0 # the number of flags; is this important?
    @uncovered_spaces = 0
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


  def won?
    ### won when:
    # no of uncovered spaces == board size - no of bombs
    # and
    # revealed all non-bomb spaces
    # flags are dealt with upon win
  end
end