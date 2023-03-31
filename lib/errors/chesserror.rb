# frozen_string_literal: true

# Base error class for all chess-related errors
class ChessError < StandardError
end

# Raised when a given position is outside the valid board coordinates
class InvalidPositionError < ChessError
  def initialize(position)
    super("#{position} is not a valid position on the board")
  end
end

# Raised when attempting to place a piece on an already occupied position
class PositionNotEmptyError < ChessError
  def initialize(position)
    super("Cannot set piece: position #{position} is not empty")
  end
end

# Raised when an object that is not an instance of Piece is passed as a piece
class NoPieceError < ChessError
  def initialize(piece)
    super("#{piece} is not an instance of Piece")
  end
end

# Raised when a piece is moved to a position that is not a valid move for that piece
class InvalidMoveError < ChessError
  def initialize(piece, destination)
    super("Invalid move: cannot move #{piece} to #{destination}")
  end
end

# Raised when a piece is moved to a position that will put the king into check
class MoveWillPutKingIntoCheckError < ChessError
  def initialize(piece, destination)
    super("Invalid move: moving #{piece} to #{destination} will put king into check")
  end
end

# Now, when you need to handle this error, you can rescue the specific PositionNotEmptyError exception:

# begin
#   board.add_piece(piece, position)
# rescue PositionNotEmptyError => e
#   puts e.message
#   # handle the error as needed
# end
