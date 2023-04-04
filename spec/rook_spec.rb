# frozen_string_literal: true

require_relative 'spec_helper'
require_relative '../lib/dependencies'

RSpec.describe Rook do
  describe 'white rook' do
    include_examples 'a chess piece', 'rook', :white, '♜'.colorize(:white)
    include_examples 'a rook', :white, '♜'.colorize(:white)
  end

  describe 'black rook' do
    include_examples 'a chess piece', 'rook', :black, '♜'.colorize(:black)
    include_examples 'a rook', :black, '♜'.colorize(:black)
  end
end
