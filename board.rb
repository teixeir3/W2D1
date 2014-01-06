class Board
  attr_reader :rows

  def self.blank_grid
    Array.new(9) { Array.new(9) }
  end

  def initialize(rows = self.class.blank_grid)
    @rows = rows
  end

  def show
    # not very pretty printing!
    self.rows.each { |row| p row }
  end

  def [](pos)
    x, y = pos[0], pos[1]
    @rows[x][y]
  end

  def []=(pos, mark)
    raise "mark already placed there!" unless self[pos].mark.nil?

    x, y = pos[0], pos[1]
    @rows[x][y] = mark
  end

  def cols
    cols = [[], [], []]
    @rows.each do |row|
      row.each_with_index do |mark, col_idx|
        cols[col_idx] << mark
      end
    end

    cols
  end

  def diagonals
    down_diag = [[0, 0], [1, 1], [2, 2]]
    up_diag = [[0, 2], [1, 1], [2, 0]]

    [down_diag, up_diag].map do |diag|
      # Note the `x, y` inside the block; this unpacks, or
      # "destructures" the argument. Read more here:
      # http://tony.pitluga.com/2011/08/08/destructuring-with-ruby.html
      diag.map { |x, y| @rows[x][y] }
    end
  end

  def dup
    duped_rows = rows.map(&:dup)
    self.class.new(duped_rows)
  end

  def empty?(pos)
    self[pos].nil?
  end


  def won?
    ### won when all bombs are found?
  end
end