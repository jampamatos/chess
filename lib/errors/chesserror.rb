# frozen_string_literal: true

class ChessError < StandardError
end

class PositionNotEmptyError < ChessError
  def initialize(position)
    super("Cannot set piece: position #{position} is not empty")
  end
end

# Now, when you need to handle this error, you can rescue the specific PositionNotEmptyError exception:

# begin
#   board.add_piece(piece, position)
# rescue PositionNotEmptyError => e
#   puts e.message
#   # handle the error as needed
# end
