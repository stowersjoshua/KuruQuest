# TODO: Skip han_to_zen conversion for final column

require 'mojinizer'

class Display::Grid
  attr_accessor :columns, :column_titles

  def initialize(data)
    @column_titles = data.first.keys
    @columns = data.map { |row| row.values_at(*column_titles) }.transpose
  end

  def draw(index: false)
    printed_columns = columns.clone

    printed_columns.map! do |cells|
      max_width = cells.map { |value| value.to_s.length }.max
      cells.map! { |value| value.to_s.ljust(max_width) }
      cells.map!(&:han_to_zen) if cells.any?(&:contains_japanese?)
      cells
    end

    printed_columns.prepend(index_column) if index

    printed_rows = printed_columns.transpose
    printed_rows.each do |cells|
      puts cells.join(' | ').prepend('  ')
    end
  end

  private

  def index_column
    row_count = columns[0].length
    cells = 1.upto(row_count).map(&:to_s)
    max_width = row_count.digits.count
    cells.map { |value| value.rjust(max_width) }
  end
end
