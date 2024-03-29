# spec/support/chess_pieces_helper.rb
module ChessPiecesHelper
  RSpec.shared_examples 'a chess piece' do |piece_name, color, symbol|
    let(:piece) { described_class.new(color) }

    describe '#initialize' do
      it "creates a #{piece_name} of the #{color} color" do
        expect(piece.color).to eq(color)
      end

      it "creates a piece of the #{piece_name} type" do
        expect(piece.type).to eq(piece_name.to_sym)
      end

      it "prints the correct symbol for a #{color} #{piece_name}" do
        expect(piece.to_s).to eq(symbol)
      end
    end
  end

  RSpec.shared_examples 'a bishop' do |color|
    let(:board) { Board.new }
    let(:bishop) { described_class.new(color) }
    let(:friendly_color_piece) { Piece.new(color, :piece, 'P') }
    let(:opposing_color_piece) { Piece.new(opposing_color(color), :piece, 'P') }
    let(:friendly_king) { King.new(color) }
    let(:opposing_king) { King.new(opposing_color(color)) }

    describe 'Bishop#possible_moves' do
      context 'when there are no pieces in the way' do
        context 'and the bishop is in the middle of the board' do
          before do
            board.place_piece(bishop, [4, 4])
          end

          it 'returns 13 possible moves' do
            expect(bishop.possible_moves(board).size).to eq(13)
          end

          it 'returns the correct movement array' do
            expect(bishop.possible_moves(board)).to contain_exactly(
              [5, 5], [6, 6], [7, 7], [3, 3], [2, 2], [1, 1], [0, 0],
              [3, 5], [2, 6], [1, 7], [5, 3], [6, 2], [7, 1]
            )
          end
        end

        context 'and the bishop is in the top left corner' do
          before do
            board.place_piece(bishop, [0, 0])
          end

          it 'returns 7 possible moves' do
            expect(bishop.possible_moves(board).size).to eq(7)
          end

          it 'returns the correct movement array' do
            expect(bishop.possible_moves(board)).to contain_exactly(
              [1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7]
            )
          end
        end
      end

      context 'when there are friendly pieces in the way' do
        context 'and the bishop is in the middle of the board' do
          before do
            board.place_piece(bishop, [4, 4])
            board.place_piece(friendly_color_piece, [6, 6])
            board.place_piece(friendly_color_piece, [2, 2])
            board.place_piece(friendly_color_piece, [6, 2])
            board.place_piece(friendly_color_piece, [2, 6])
          end

          it 'returns 4 possible moves' do
            expect(bishop.possible_moves(board).size).to eq(4)
          end

          it 'returns the correct movement array' do
            expect(bishop.possible_moves(board)).to contain_exactly(
              [5, 5], [3, 3], [5, 3], [3, 5]
            )
          end
        end

        context 'and the bishop is in the top left corner' do
          before do
            board.place_piece(bishop, [0, 0])
            board.place_piece(friendly_color_piece, [2, 2])
            board.place_piece(friendly_color_piece, [3, 3])
            board.place_piece(friendly_color_piece, [4, 4])
            board.place_piece(friendly_color_piece, [5, 5])
          end

          it 'returns 1 possible moves' do
            expect(bishop.possible_moves(board).size).to eq(1)
          end

          it 'returns the correct movement array' do
            expect(bishop.possible_moves(board)).to contain_exactly(
              [1, 1]
            )
          end
        end
      end

      context 'when there are opposing pieces in the way' do
        context 'and the bishop is in the middle of the board' do
          before do
            board.place_piece(bishop, [4, 4])
            board.place_piece(opposing_color_piece, [6, 6])
            board.place_piece(opposing_color_piece, [2, 2])
            board.place_piece(opposing_color_piece, [6, 2])
            board.place_piece(opposing_color_piece, [2, 6])
          end

          it 'returns 8 possible moves' do
            expect(bishop.possible_moves(board).size).to eq(8)
          end

          it 'returns the correct movement array' do
            expect(bishop.possible_moves(board)).to contain_exactly(
              [5, 5], [6, 6], [3, 3], [2, 2], [5, 3], [6, 2], [3, 5], [2, 6]
            )
          end
        end

        context 'and the bishop is in the top left corner' do
          before do
            board.place_piece(bishop, [0, 0])
            board.place_piece(opposing_color_piece, [2, 2])
            board.place_piece(opposing_color_piece, [3, 3])
            board.place_piece(opposing_color_piece, [4, 4])
            board.place_piece(opposing_color_piece, [5, 5])
          end

          it 'returns 2 possible moves' do
            expect(bishop.possible_moves(board).size).to eq(2)
          end

          it 'returns the correct movement array' do
            expect(bishop.possible_moves(board)).to contain_exactly(
              [1, 1], [2, 2]
            )
          end
        end
      end
    end

    describe 'GameManager#move_piece' do
      context 'when moving a bishop' do
        before do
          board.place_piece(bishop, [4, 4])
          board.place_piece(friendly_color_piece, [7, 7])
          board.place_piece(opposing_color_piece, [0, 0])
          board.place_piece(friendly_king, [7, 4])
          board.place_piece(opposing_king, [0, 4])
        end

        let(:game_manager) { GameManager.new(board) }

        context 'to a valid location' do
          before do
            game_manager.turn = color
          end

          it 'moves the bishop to the new location' do
            game_manager.move_piece([4, 4], [6, 6])
            expect(game_manager.board.piece_at([6, 6])).to eq(bishop)
          end

          it 'removes the bishop from the old location' do
            game_manager.move_piece([4, 4], [6, 6])
            expect(board.grid[4][4]).to be_nil
          end

          it 'returns the correct move notation when called #to_s' do
            expect(game_manager.move_piece([4, 4], [6, 6]).to_s).to eq('Bg2')
          end
        end

        context 'to an invalid location' do
          before do
            game_manager.turn = color
          end

          it 'raises an InvalidMoveError' do
            expect { game_manager.move_piece([4, 4], [6, 5]) }.to raise_error(InvalidMoveError)
          end
        end

        context 'to a location occupied by a friendly piece' do
          before do
            game_manager.turn = color
          end

          it 'raises a PositionNotEmptyError' do
            expect { game_manager.move_piece([4, 4], [7, 7]) }.to raise_error(PositionNotEmptyError)
          end
        end

        context 'to a location occupied by an opposing piece' do
          before do
            game_manager.turn = color
          end

          it 'moves the bishop to the new location' do
            game_manager.move_piece([4, 4], [0, 0])
            expect(board.grid[0][0]).to eq(bishop)
          end

          it 'removes the bishop from the old location' do
            game_manager.move_piece([4, 4], [0, 0])
            expect(board.grid[4][4]).to be_nil
          end

          it 'removes the opposing piece from the board' do
            game_manager.move_piece([4, 4], [0, 0])
            expect(board.grid[0][0]).to eq(bishop)
          end

          it 'removes the opposing piece from active pieces' do
            game_manager.move_piece([4, 4], [0, 0])
            expect(game_manager.board.active_pieces.values).not_to include(opposing_color_piece)
          end

          it 'returns the correct move notation when called #to_s' do
            expect(game_manager.move_piece([4, 4], [0, 0]).to_s).to eq('Bxa8')
          end
        end
      end
    end
  end

  RSpec.shared_examples 'a king' do |color|
    let(:board) { Board.new }
    let(:king) { King.new(color) }
    let(:opposing_king) { King.new(opposing_color(color)) }
    let(:friendly_color_piece) { Piece.new(color, :piece, 'P') }
    let(:opposing_color_piece) { Piece.new(opposing_color(color), :piece, 'P') }

    describe 'King#possible_moves' do
      context 'when there are no pieces in the way' do
        context 'and the king is in the middle of the board' do
          before do
            board.place_piece(king, [4, 4])
            board.place_piece(opposing_king, [0, 0])
          end

          it 'returns 8 possible moves' do
            expect(king.possible_moves(board).size).to eq(8)
          end

          it 'returns the correct movement array' do
            expect(king.possible_moves(board)).to contain_exactly(
              [3, 3], [4, 3], [5, 3], [3, 4], [5, 4], [3, 5], [4, 5], [5, 5]
            )
          end
        end

        context 'and the king is in the top left corner' do
          before do
            board.place_piece(king, [0, 0])
            board.place_piece(opposing_king, [7, 7])
          end

          it 'returns 3 possible moves' do
            expect(king.possible_moves(board).size).to eq(3)
          end

          it 'returns the correct movement array' do
            expect(king.possible_moves(board)).to contain_exactly(
              [0, 1], [1, 0], [1, 1]
            )
          end
        end

        context 'and the king is in the bottom middle part of the board' do
          before do
            board.place_piece(king, [4, 7])
            board.place_piece(opposing_king, [0, 0])
          end

          it 'returns 5 possible moves' do
            expect(king.possible_moves(board).size).to eq(5)
          end

          it 'returns the correct movement array' do
            expect(king.possible_moves(board)).to contain_exactly(
              [3, 6], [4, 6], [5, 6], [3, 7], [5, 7]
            )
          end
        end
      end

      context 'when there are friendly pieces in the way' do
        context 'and the king is in the middle of the board' do
          before do
            board.place_piece(king, [4, 4])
            board.place_piece(friendly_color_piece, [2, 2])
            board.place_piece(friendly_color_piece, [4, 3])
            board.place_piece(friendly_color_piece, [5, 3])
            board.place_piece(friendly_color_piece, [3, 4])
            board.place_piece(friendly_color_piece, [5, 4])
            board.place_piece(friendly_color_piece, [3, 5])
            board.place_piece(friendly_color_piece, [4, 5])
            board.place_piece(friendly_color_piece, [6, 6])
            board.place_piece(opposing_king, [0, 0])
          end

          it 'returns 2 possible moves' do
            expect(king.possible_moves(board).size).to eq(2)
          end

          it 'returns the correct movement array' do
            expect(king.possible_moves(board)).to contain_exactly(
              [5, 5], [3, 3]
            )
          end
        end

        context 'and the king is in the top left corner' do
          before do
            board.place_piece(king, [0, 0])
            board.place_piece(friendly_color_piece, [0, 1])
            board.place_piece(friendly_color_piece, [1, 0])
            board.place_piece(friendly_color_piece, [1, 1])
            board.place_piece(opposing_king, [7, 7])
          end

          it 'returns 0 possible moves' do
            expect(king.possible_moves(board).size).to eq(0)
          end

          it 'returns the correct movement array' do
            expect(king.possible_moves(board)).to be_empty
          end
        end

        context 'and the king is in the bottom middle part of the board' do
          before do
            board.place_piece(king, [4, 7])
            board.place_piece(friendly_color_piece, [3, 6])
            board.place_piece(friendly_color_piece, [4, 6])
            board.place_piece(friendly_color_piece, [5, 6])
            board.place_piece(friendly_color_piece, [3, 7])
            board.place_piece(friendly_color_piece, [5, 7])
            board.place_piece(opposing_king, [0, 0])
          end

          it 'returns 0 possible moves' do
            expect(king.possible_moves(board).size).to eq(0)
          end
        end
      end

      context 'when there are opposing pieces in the way' do
        context 'and the king is in the middle of the board' do
          before do
            board.place_piece(king, [4, 4])
            board.place_piece(opposing_color_piece, [2, 2])
            board.place_piece(opposing_color_piece, [4, 3])
            board.place_piece(opposing_color_piece, [5, 3])
            board.place_piece(opposing_color_piece, [3, 4])
            board.place_piece(opposing_color_piece, [5, 4])
            board.place_piece(opposing_color_piece, [3, 5])
            board.place_piece(opposing_color_piece, [4, 5])
            board.place_piece(opposing_color_piece, [6, 6])
            board.place_piece(opposing_king, [0, 0])
          end

          it 'returns 8 possible moves' do
            expect(king.possible_moves(board).size).to eq(8)
          end

          it 'returns the correct movement array' do
            expect(king.possible_moves(board)).to contain_exactly(
              [3, 3], [3, 4], [3, 5], [4, 3], [4, 5], [5, 3], [5, 4], [5, 5]
            )
          end
        end

        context 'and the king is in the top left corner' do
          before do
            board.place_piece(king, [0, 0])
            board.place_piece(opposing_color_piece, [0, 1])
            board.place_piece(opposing_color_piece, [1, 0])
            board.place_piece(opposing_color_piece, [1, 1])
            board.place_piece(opposing_king, [7, 7])
          end

          it 'returns 3 possible moves' do
            expect(king.possible_moves(board).size).to eq(3)
          end

          it 'returns the correct movement array' do
            expect(king.possible_moves(board)).to contain_exactly(
              [0, 1], [1, 0], [1, 1]
            )
          end
        end
      end

      context 'when possible moves square are attacked by opposing pieces' do
        before do
          board.place_piece(king, [4, 4])
          board.place_piece(opposing_king, [7, 7])
          board.place_piece(Rook.new(opposing_color(king.color)), [3, 0])
          board.place_piece(Rook.new(opposing_color(king.color)), [0, 0])
        end

        it 'returns 5 possible moves' do
          expect(king.possible_moves(board).size).to eq(5)
        end

        it 'returns the correct movement array' do
          expect(king.possible_moves(board)).to contain_exactly(
            [5, 4], [4, 5], [4, 3], [5, 5], [5, 3]
          )
        end
      end

      context 'when in a classic stalemate position' do
        before do
          board.place_piece(king, [0, 0])
          board.place_piece(Rook.new(opposing_color(king.color)), [1, 1])
          board.place_piece(King.new(opposing_color(king.color)), [2, 2])
        end

        it 'returns 0 possible moves' do
          expect(king.possible_moves(board).size).to eq(0)
        end
      end
    end

    describe 'GameManager#move_piece' do
      context 'when moving the king' do
        before do
          board.place_piece(king, [4, 4])
          board.place_piece(friendly_color_piece, [4, 3])
          board.place_piece(opposing_color_piece, [5, 4])
          board.place_piece(opposing_king, [7, 7])
        end

        let(:game_manager) { GameManager.new(board) }

        context 'to a valid location' do
          before do
            game_manager.turn = color
          end

          it 'moves the king to the new location' do
            game_manager.move_piece([4, 4], [5, 3])
            expect(game_manager.board.piece_at([5, 3])).to eq(king)
          end

          it 'removes the king from the old location' do
            game_manager.move_piece([4, 4], [5, 3])
            expect(game_manager.board.piece_at([4, 4])).to be_nil
          end

          it 'returns the correct move notation when called #to_s' do
            expect(game_manager.move_piece([4, 4], [5, 3]).to_s).to eq('Kd3')
          end
        end

        context 'to an invalid location' do
          before do
            game_manager.turn = color
          end

          it 'raises an InvalidMoveError' do
            expect { game_manager.move_piece([4, 4], [6, 2]) }.to raise_error(InvalidMoveError)
          end
        end

        context 'to a location occupied by a friendly piece' do
          before do
            game_manager.turn = color
          end

          it 'raises a PositionNotEmtpyError' do
            expect { game_manager.move_piece([4, 4], [4, 3]) }.to raise_error(PositionNotEmptyError)
          end
        end

        context 'to a location occupied by an opposing piece' do
          before do
            game_manager.turn = color
          end

          it 'moves the king to the new location' do
            game_manager.move_piece([4, 4], [5, 4])
            expect(game_manager.board.piece_at([5, 4])).to eq(king)
          end

          it 'removes the king from the old location' do
            game_manager.move_piece([4, 4], [5, 4])
            expect(game_manager.board.piece_at([4, 4])).to be_nil
          end

          it 'removes the opposing piece from the new location' do
            game_manager.move_piece([4, 4], [5, 4])
            expect(game_manager.board.piece_at([5, 4])).to eq(king)
          end

          it 'removes the opposing piece from active pieces' do
            game_manager.move_piece([4, 4], [5, 4])
            expect(game_manager.board.active_pieces.values).not_to include(opposing_color_piece)
          end

          it 'returns the correct move notation when called #to_s' do
            expect(game_manager.move_piece([4, 4], [5, 4]).to_s).to eq('Kxe3')
          end
        end
      end
    end
  end

  RSpec.shared_examples 'a knight' do |color|
    let(:board) { Board.new }
    let(:knight) {described_class.new(color)}
    let(:friendly_color_piece) {Piece.new(color, :piece, 'P') }
    let(:opposing_color_piece) {Piece.new(opposing_color(color), :piece, 'P') }
    let(:opposing_king) {King.new(opposing_color(color)) }
    let(:friendly_king) {King.new(color) }

    describe 'Knight#possible_moves' do
      context 'when there are no pieces in the way' do
        context 'and the knight is in the middle of the board' do
          before do
            board.place_piece(knight, [4, 4])
          end

          it 'returns 8 possible moves' do
            expect(knight.possible_moves(board).size).to eq(8)
          end

          it 'returns the correct movement array' do
            expect(knight.possible_moves(board)).to contain_exactly(
              [2, 3], [2, 5], [3, 2], [3, 6], [5, 2], [5, 6], [6, 3], [6, 5]
            )
          end
        end

        context 'and the knight is in the top left corner' do
          before do
            board.place_piece(knight, [0, 0])
          end

          it 'returns 2 possible moves' do
            expect(knight.possible_moves(board).size).to eq(2)
          end

          it 'returns the correct movement array' do
            expect(knight.possible_moves(board)).to contain_exactly(
              [1, 2], [2, 1]
            )
          end
        end
      end

      context 'when there are friendly pieces in the way' do
        context 'and they surround the knight in the middle of the board' do
          before do
            board.place_piece(knight, [4, 4])
            board.place_piece(friendly_color_piece, [3, 3])
            board.place_piece(friendly_color_piece, [3, 4])
            board.place_piece(friendly_color_piece, [3, 5])
            board.place_piece(friendly_color_piece, [4, 3])
            board.place_piece(friendly_color_piece, [4, 5])
            board.place_piece(friendly_color_piece, [5, 3])
            board.place_piece(friendly_color_piece, [5, 4])
            board.place_piece(friendly_color_piece, [5, 5])
          end

          it 'returns 8 possible moves' do
            expect(knight.possible_moves(board).size).to eq(8)
          end

          it 'returns the correct movement array' do
            expect(knight.possible_moves(board)).to contain_exactly(
              [2, 3], [2, 5], [3, 2], [3, 6], [5, 2], [5, 6], [6, 3], [6, 5]
            )
          end
        end

        context 'and they are in the possible landing squares of knight' do
          before do
            board.place_piece(knight, [4, 4])
            board.place_piece(friendly_color_piece, [2, 3])
            board.place_piece(friendly_color_piece, [2, 5])
            board.place_piece(friendly_color_piece, [3, 2])
            board.place_piece(friendly_color_piece, [3, 6])
            board.place_piece(friendly_color_piece, [5, 2])
            board.place_piece(friendly_color_piece, [5, 6])
            board.place_piece(friendly_color_piece, [6, 3])
            board.place_piece(friendly_color_piece, [6, 5])
          end

          it 'returns 0 possible moves' do
            expect(knight.possible_moves(board).size).to eq(0)
          end
        end
      end

      context 'when there are opposing pieces in the way' do
        context 'and they surround the knight in the middle of the board' do
          before do
            board.place_piece(knight, [4, 4])
            board.place_piece(opposing_color_piece, [3, 3])
            board.place_piece(opposing_color_piece, [3, 4])
            board.place_piece(opposing_color_piece, [3, 5])
            board.place_piece(opposing_color_piece, [4, 3])
            board.place_piece(opposing_color_piece, [4, 5])
            board.place_piece(opposing_color_piece, [5, 3])
            board.place_piece(opposing_color_piece, [5, 4])
            board.place_piece(opposing_color_piece, [5, 5])
          end

          it 'returns 8 possible moves' do
            expect(knight.possible_moves(board).size).to eq(8)
          end

          it 'returns the correct movement array' do
            expect(knight.possible_moves(board)).to contain_exactly(
              [2, 3], [2, 5], [3, 2], [3, 6], [5, 2], [5, 6], [6, 3], [6, 5]
            )
          end
        end

        context 'and they are in the possible landing squares of knight' do
          before do
            board.place_piece(knight, [4, 4])
            board.place_piece(opposing_color_piece, [2, 3])
            board.place_piece(opposing_color_piece, [2, 5])
            board.place_piece(opposing_color_piece, [3, 2])
            board.place_piece(opposing_color_piece, [3, 6])
            board.place_piece(opposing_color_piece, [5, 2])
            board.place_piece(opposing_color_piece, [5, 6])
            board.place_piece(opposing_color_piece, [6, 3])
            board.place_piece(opposing_color_piece, [6, 5])
          end

          it 'returns 8 possible moves' do
            expect(knight.possible_moves(board).size).to eq(8)
          end

          it 'returns the correct movement array' do
            expect(knight.possible_moves(board)).to contain_exactly(
              [2, 3], [2, 5], [3, 2], [3, 6], [5, 2], [5, 6], [6, 3], [6, 5]
            )
          end
        end
      end
      describe 'GameManager#move_piece' do
        context 'when moving the knight' do
          before do
            board.place_piece(knight, [4, 4])
            board.place_piece(friendly_color_piece, [2, 3])
            board.place_piece(opposing_color_piece, [2, 5])
            board.place_piece(friendly_king, [3, 2])
            board.place_piece(opposing_king, [3, 6])
          end

          let(:game_manager) { GameManager.new(board) }

          context 'to a valid location' do
            before do
              game_manager.turn = color
            end

            it 'moves the knight to the new location' do
              game_manager.move_piece([4, 4], [6, 5])
              expect(game_manager.board.piece_at([6, 5])).to eq(knight)
            end

            it 'removes the knight from the old location' do
              game_manager.move_piece([4, 4], [6, 5])
              expect(game_manager.board.piece_at([4, 4])).to eq(nil)
            end

            it 'returns the correct move notation whe called #to_s' do
              expect(game_manager.move_piece([4, 4], [6, 5]).to_s).to eq('Nf2')
            end
          end

          context 'to an invalid location' do
            before do
              game_manager.turn = color
            end

            it 'raises an InvalidMoveError' do
              expect { game_manager.move_piece([4, 4], [4, 5]) }.to raise_error(InvalidMoveError)
            end
          end

          context 'to a location occupied by a friendly piece' do
            before do
              game_manager.turn = color
            end

            it 'raises a PositionNotEmtpyError' do
              expect { game_manager.move_piece([4, 4], [2, 3]) }.to raise_error(PositionNotEmptyError)
            end
          end

          context 'to a location occupied by an opposing piece' do
            before do
              game_manager.turn = color
            end

            it 'moves the knight to the new location' do
              game_manager.move_piece([4, 4], [2, 5])
              expect(game_manager.board.piece_at([2, 5])).to eq(knight)
            end

            it 'removes the knight from the old location' do
              game_manager.move_piece([4, 4], [2, 5])
              expect(game_manager.board.piece_at([4, 4])).to eq(nil)
            end

            it 'removes the opposing piece from the board' do
              game_manager.move_piece([4, 4], [2, 5])
              expect(game_manager.board.piece_at([2, 5])).to eq(knight)
            end

            it 'removes the opposing piece from active pieces' do
              game_manager.move_piece([4, 4], [2, 5])
              expect(game_manager.board.active_pieces.values).to_not include(opposing_color_piece)
            end

            it 'returns the correct move notation whe called #to_s' do
              expect(game_manager.move_piece([4, 4], [2, 5]).to_s).to eq('Nxf6')
            end
          end
        end
      end
    end
  end

  RSpec.shared_examples 'a queen' do |color|
    let(:board) { Board.new }
    let(:queen) { described_class.new(color) }
    let(:friendly_color_piece) { described_class.new(color) }
    let(:opposing_color_piece) { described_class.new(opposing_color(color)) }
    let(:friendly_king) { King.new(color) }
    let(:opposing_king) { King.new(opposing_color(color)) }

    describe 'Queen#possible_moves' do
      context 'when there are no pieces in the way' do
        context 'and the queen is in the center of the board' do
          before do
            board.place_piece(queen, [4, 4])
          end

          it 'returns 27 possible moves' do
            expect(queen.possible_moves(board).size).to eq(27)
          end

          it 'returns the correct movement array' do
            expect(queen.possible_moves(board)).to contain_exactly(
              [0, 0], [0, 4], [1, 1], [1, 4], [1, 7], [2, 2], [2, 4],
              [2, 6], [3, 3], [3, 4], [3, 5], [4, 0], [4, 3], [4, 5],
              [4, 6], [4, 7], [5, 3], [5, 4], [5, 5], [6, 2], [6, 4],
              [6, 6], [7, 1], [7, 4], [7, 7], [4, 1], [4, 2]
            )
          end
        end

        context 'and the queen is in the corner of the board' do
          before do
            board.place_piece(queen, [0, 0])
          end

          it 'returns 21 possible moves' do
            expect(queen.possible_moves(board).size).to eq(21)
          end

          it 'returns the correct movement array' do
            expect(queen.possible_moves(board)).to contain_exactly(
              [1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7],
              [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7],
              [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0]
            )
          end
        end
      end

      context 'when there are friendly pieces in the way' do
        context 'and the queen is in the middle of the board' do
          before do
            board.place_piece(queen, [4, 4])
            board.place_piece(friendly_color_piece, [4, 0])
            board.place_piece(friendly_color_piece, [0, 4])
          end

          it 'returns 25 possible moves' do
            expect(queen.possible_moves(board).size).to eq(25)
          end

          it 'returns the correct movement array' do
            expect(queen.possible_moves(board)).to contain_exactly(
              [0, 0], [1, 1], [1, 4], [1, 7], [2, 2], [2, 4], [2, 6],
              [3, 3], [3, 4], [3, 5], [4, 5], [4, 6], [4, 7], [5, 3],
              [5, 4], [5, 5], [6, 2], [6, 4], [6, 6], [7, 1], [7, 4],
              [4, 1], [4, 2], [4, 3], [7, 7]
            )
          end
        end
      end

      context 'when there are opposing pieces in the way' do
        context 'and the queen is in the middle of the board' do
          before do
            board.place_piece(queen, [4, 4])
            board.place_piece(opposing_color_piece, [4, 0])
            board.place_piece(opposing_color_piece, [0, 4])
          end

          it 'returns 27 possible moves' do
            expect(queen.possible_moves(board).size).to eq(27)
          end

          it 'returns the correct movement array' do
            expect(queen.possible_moves(board)).to contain_exactly(
              [0, 0], [0, 4], [1, 1], [1, 4], [1, 7], [2, 2], [2, 4],
              [2, 6], [3, 3], [3, 4], [3, 5], [4, 0], [4, 5], [4, 6],
              [4, 7], [5, 3], [5, 4], [5, 5], [6, 2], [6, 4], [6, 6],
              [7, 1], [7, 4], [7, 7], [4, 1], [4, 2], [4, 3]
            )
          end
        end
      end
    end

    describe 'GameManager#move_piece' do
      context 'when moving a queen' do
        before do
          board.place_piece(queen, [4, 4])
          board.place_piece(friendly_color_piece, [4, 0])
          board.place_piece(opposing_color_piece, [0, 4])
          board.place_piece(friendly_king, [6, 6])
          board.place_piece(opposing_king, [1, 1])
        end

        let(:game_manager) { GameManager.new(board) }

        context 'to a valid location' do
          before do
            game_manager.turn = color
          end

          it 'moves the queen to the new location' do
            game_manager.move_piece([4, 4], [3, 3])
            expect(game_manager.board.piece_at([3, 3])).to eq(queen)
          end

          it 'removes the queen from the old location' do
            game_manager.move_piece([4, 4], [3, 3])
            expect(game_manager.board.piece_at([4, 4])).to be_nil
          end

          it 'returns the correct move notation when called #to_s' do
            expect(game_manager.move_piece([4, 4], [3, 3]).to_s).to eq('Qd5')
          end
        end

        context 'to an invalid location' do
          before do
            game_manager.turn = color
          end

          it 'raises an InvalidMoveError' do
            expect { game_manager.move_piece([4, 4], [0, 7]) }.to raise_error(InvalidMoveError)
          end
        end

        context 'to a location occupied by a friendly piece' do
          before do
            game_manager.turn = color
          end

          it 'raises an PositionNotEmptyError' do
            expect { game_manager.move_piece([4, 4], [4, 0]) }.to raise_error(PositionNotEmptyError)
          end
        end

        context 'to a location occupied by an opposing piece' do
          before do
            game_manager.turn = color
          end

          it 'moves the queen to the new location' do
            game_manager.move_piece([4, 4], [0, 4])
            expect(game_manager.board.piece_at([0, 4])).to eq(queen)
          end

          it 'removes the queen from the old location' do
            game_manager.move_piece([4, 4], [0, 4])
            expect(game_manager.board.piece_at([4, 4])).to be_nil
          end

          it 'removes the opposing piece from the board' do
            game_manager.move_piece([4, 4], [0, 4])
            expect(game_manager.board.piece_at([0, 4])).to eq(queen)
          end

          it 'returns the correct move notation when called #to_s' do
            expect(game_manager.move_piece([4, 4], [0, 4]).to_s).to eq('Qxe8')
          end
        end
      end
    end
  end

  RSpec.shared_examples 'a rook' do |color|
    let(:board) { Board.new }
    let(:rook) { described_class.new(color) }
    let(:friendly_color_piece) { described_class.new(color) }
    let(:opposing_color_piece) { described_class.new(opposing_color(color)) }
    let(:friendly_king) { King.new(color) }
    let(:opposing_king) { King.new(opposing_color(color)) }

    describe 'Rook#possible_moves' do
      context 'when there are no pieces in the way' do
        context 'and the rook is in the center of the board' do
          before do
            board.place_piece(rook, [4, 4])
          end

          it 'returns 14 possible moves' do
            expect(rook.possible_moves(board).size).to eq(14)
          end

          it 'returns the correct movement array' do
            expect(rook.possible_moves(board)).to contain_exactly(
              [0, 4], [1, 4], [2, 4], [3, 4], [4, 0], [4, 1], [4, 2],
              [4, 3], [4, 5], [4, 6], [4, 7], [5, 4], [6, 4], [7, 4]
            )
          end
        end

        context 'and the rook is in the corner of the board' do
          before do
            board.place_piece(rook, [0, 0])
          end

          it 'returns 14 possible moves' do
            expect(rook.possible_moves(board).size).to eq(14)
          end

          it 'returns the correct movement array' do
            expect(rook.possible_moves(board)).to contain_exactly(
              [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7],
              [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0]
            )
          end
        end
      end

      context 'when there are friendly pieces in the way' do
        context 'and the rook is in the center of the board' do
          before do
            board.place_piece(rook, [4, 4])
            board.place_piece(friendly_color_piece, [4, 0])
            board.place_piece(friendly_color_piece, [0, 4])
          end

          it 'returns 12 possible moves' do
            expect(rook.possible_moves(board).size).to eq(12)
          end

          it 'returns the correct movement array' do
            expect(rook.possible_moves(board)).to contain_exactly(
              [1, 4], [2, 4], [3, 4], [4, 5], [4, 6], [4, 7],
              [5, 4], [6, 4], [7, 4], [4, 1], [4, 2], [4, 3]
            )
          end
        end
      end

      context 'when there are opposing pieces in the way' do
        context 'and the rook is in the center of the board' do
          before do
            board.place_piece(rook, [4, 4])
            board.place_piece(opposing_color_piece, [4, 0])
            board.place_piece(opposing_color_piece, [0, 4])
          end

          it 'returns 14 possible moves' do
            expect(rook.possible_moves(board).size).to eq(14)
          end

          it 'returns the correct movement array' do
            expect(rook.possible_moves(board)).to contain_exactly(
              [1, 4], [2, 4], [3, 4], [4, 5], [4, 6], [4, 7],
              [5, 4], [6, 4], [7, 4], [4, 1], [4, 2], [4, 3],
              [0, 4], [4, 0]
            )
          end
        end
      end
    end
    describe 'GameManager#move_piece' do
      context 'when moving the rook' do
        before do
          board.place_piece(rook, [4, 4])
          board.place_piece(friendly_color_piece, [4, 0])
          board.place_piece(opposing_color_piece, [0, 4])
          board.place_piece(friendly_king, [1, 1])
          board.place_piece(opposing_king, [6, 6])
        end

        let(:game_manager) { GameManager.new(board) }

        context 'to a valid location' do
          before do
            game_manager.turn = color
          end

          it 'moves the rook to the new location' do
            game_manager.move_piece([4, 4], [4, 3])
            expect(game_manager.board.piece_at([4, 3])).to eq(rook)
          end

          it 'removes the rook from the old location' do
            game_manager.move_piece([4, 4], [4, 3])
            expect(game_manager.board.piece_at([4, 4])).to be_nil
          end

          it 'returns the correct move notation when called #to_s' do
            expect(game_manager.move_piece([4, 4], [4, 3]).to_s).to eq('Rd4')
          end
        end

        context 'to an invalid location' do
          before do
            game_manager.turn = color
          end

          it 'raises an InvalidMoveError' do
            expect { game_manager.move_piece([4, 4], [0, 0]) }.to raise_error(InvalidMoveError)
          end
        end

        context 'to a location with a friendly piece' do
          before do
            game_manager.turn = color
          end

          it 'raises a PositionNotEmptyError' do
            expect { game_manager.move_piece([4, 4], [4, 0]) }.to raise_error(PositionNotEmptyError)
          end
        end

        context 'to a location with an opposing piece' do
          before do
            game_manager.turn = color
          end

          it 'moves the rook to the new location' do
            game_manager.move_piece([4, 4], [0, 4])
            expect(game_manager.board.piece_at([0, 4])).to eq(rook)
          end

          it 'removes the rook from the old location' do
            game_manager.move_piece([4, 4], [0, 4])
            expect(game_manager.board.piece_at([4, 4])).to be_nil
          end

          it 'removes the opposing piece from the board' do
            game_manager.move_piece([4, 4], [0, 4])
            expect(game_manager.board.piece_at([0, 4])).to eq(rook)
          end

          it 'returns the correct move notation when called #to_s' do
            expect(game_manager.move_piece([4, 4], [0, 4]).to_s).to eq('Rxe8')
          end
        end
      end
    end
  end

  def opposing_color(color)
    color == :white ? :black : :white
  end
end
