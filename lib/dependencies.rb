# External libraries
require 'colorize'

# Local Classes
require_relative 'gamemanager'
require_relative 'board'
require_relative 'boardrender'
require_relative 'piece'
require_relative 'move'

# Piece subclasses
require_relative 'pieces/pawn'
require_relative 'pieces/rook'
require_relative 'pieces/knight'
require_relative 'pieces/bishop'
require_relative 'pieces/queen'
require_relative 'pieces/king'

# Errors
require_relative 'errors/chesserror'
