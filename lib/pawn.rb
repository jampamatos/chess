# frozen_string_literal: true

require_relative 'piece'
require 'colorize'

class Pawn < Piece
  def initialize(color, moved = false)
    symbol = color == :white ? '♙'.colorize(color) : '♟'.colorize(color)
    super(color, :pawn, symbol)
    @moved = moved
  end

  def to_unicode
    @color == 'white' ? " \u2659 " : " \u265F "
  end

  def possible_moves(board, position = @position)
    moves = []

    row, col = position

    # Determine the direction and distance the pawn can move
    direction = color == 'white' ? -1 : 1
    step_one = [row + direction, col]
    step_two = [row + 2 * direction, col]
    diagonal_left = [row + direction, col - 1]
    diagonal_right = [row + direction, col + 1]

    # Check if step one is a valid move
    if board[step_one].nil?
      moves << step_one
      moves << step_two if !moved && board[step_two].nil?
    end

    # Check if diagonal left is a valid move
    if col > 0
      piece = board[diagonal_left]
      if piece && piece.color != color
        moves << diagonal_left
      elsif board.en_passant == diagonal_left
        moves << diagonal_left
      end
    end

    # Check if diagonal right is a valid move
    if col < 7
      piece = board[diagonal_right]
      if piece && piece.color != color
        moves << diagonal_right
      elsif board.en_passant == diagonal_right
        moves << diagonal_right
      end
    end

    moves
  end

  def move(destination, board)
    curr_row = @position[0]
    row = destination[0]
    col = destination[1]
    if board.en_passant == [destination[0] + (color == 'white' ? 1 : -1), destination[1]]
      # En passant capture
      row += (color == 'white' ? -1 : 1)
      piece = board[[row, col]]
      board.remove_piece([row, col])
      board.en_passant = nil
      board.set_piece(self, destination)
      @position = destination
      @moved = true
      "#{to_chess_notation(position[0], position[1])}x#{to_chess_notation(destination[0], destination[1], piece.symbol)} e.p."
    elsif destination[0] == (color == 'white' ? 0 : 7)
      puts 'Pawn promotion'
      new_piece = choose_promotion_piece
      game_manager.promote_pawn(self, new_piece)
      "#{to_chess_notation(position[0], position[1])}-#{to_chess_notation(destination[0], destination[1])}=#{new_piece.symbol}"
    else
      notation = super(destination, board)
      if (curr_row - row).abs == 2
        en_passant_row = color == 'white' ? row + 1 : row - 1
        board.en_passant = [en_passant_row, col]
      else
        board.en_passant = nil
      end
      notation
    end
  end

  private

  def choose_promotion_piece
    puts 'Choose a piece to promote to: '
    puts '1. Queen'
    puts '2. Rook'
    puts '3. Bishop'
    puts '4. Knight'
    choice = gets.chomp.to_i

    loop do
      case choice
      when 1
        return Queen.new(color)
      when 2
        return Rook.new(color)
      when 3
        return Bishop.new(color)
      when 4
        return Knight.new(color)
      else
        puts 'Invalid input, please try again.'
      end
    end
  end
end
