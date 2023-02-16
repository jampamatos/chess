# frozen_string_literal: true

require_relative '../lib/square'

describe Square do
  let(:x) { 1 }
  let(:y) { 1 }
  let(:color) { Square::BLACK_COLOR }
  let(:piece) { double('Piece') }
  let(:selected) { false }

  describe '#initialize' do
    subject { Square.new(x, y, color, piece, selected) }

    it 'sets the x coordinates' do
      expect(subject.instance_variable_get(:@x)).to eq(x)
    end

    it 'sets the y coordinates' do
      expect(subject.instance_variable_get(:@y)).to eq(y)
    end

    it 'sets the color' do
      expect(subject.instance_variable_get(:@color)).to eq(color)
    end

    it 'sets the piece' do
      expect(subject.instance_variable_get(:@piece)).to eq(piece)
    end

    it 'sets the selected attribute' do
      expect(subject.instance_variable_get(:@selected)).to eq(selected)
    end
  end

  describe '#occupied?' do
    subject { Square.new(x, y, color, piece, selected).occupied? }

    context 'when the square is not occupied' do
      let(:piece) { nil }

      it 'returns false' do
        expect(subject).to be false
      end
    end

    context 'when the square is occupied' do
      let(:piece) { double('Piece') }

      it 'returns true' do
        expect(subject).to be true
      end
    end
  end

  describe '#to_s' do
    context 'when the square is occupied and white' do
      subject { Square.new(x, y, :cyan, piece, selected).to_s }

      let(:piece) { double('Piece', symbol: 'P') }

      it 'returns the symbol of the piece with the light white background color' do
        expected_string = "         \n    P    \n         ".colorize(background: :cyan)
        puts "Subject :\n#{subject}"
        puts "Expected:\n#{expected_string}"
        expect(subject).to eq(expected_string)
      end
    end

    context 'when the square is occupied and black' do
      subject { Square.new(x, y, :blue, piece, selected).to_s }

      let(:piece) { double('Piece', symbol: 'P') }

      it 'returns the symbol of the piece with the default (black) background color' do
        expected_string = "         \n    P    \n         ".colorize(background: :blue)
        puts "Subject :\n#{subject}"
        puts "Expected:\n#{expected_string}"
        expect(subject).to eq(expected_string)
      end
    end

    context 'when the square is selected and occupied' do
      subject { Square.new(x, y, color, piece, true).to_s }

      let(:piece) { double('Piece', symbol: 'P') }

      it 'returns the symbol of the piece with the light yellow background color' do
        expected_string = "         \n    P    \n         ".colorize(background: :light_yellow)
        puts "Subject :\n#{subject}"
        puts "Expected:\n#{expected_string}"
        expect(subject).to eq(expected_string)
      end
    end

    context 'when the square is selected and unoccupied' do
      subject { Square.new(x, y, color, nil, true).to_s }

      it 'returns three spaces with the light yellow background color' do
        expected_string = "         \n         \n         ".colorize(background: :light_yellow)
        puts "Subject :\n#{subject}"
        puts "Expected:\n#{expected_string}"
        expect(subject).to eq(expected_string)
      end
    end

    context 'when the square is unoccupied and not selected' do
      subject { Square.new(x, y, color).to_s }

      it 'returns three spaces with the black background color' do
        expected_string = "         \n         \n         ".colorize(background: :blue)
        puts "Subject :\n#{subject}"
        puts "Expected:\n#{expected_string}"
        expect(subject).to eq(expected_string)
      end
    end
  end
end
