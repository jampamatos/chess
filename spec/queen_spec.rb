# frozen_string_literal: true

require_relative 'spec_helper'
require_relative '../lib/dependencies'

RSpec.describe Queen do
  describe 'white queen' do
    include_examples 'a chess piece', 'queen', :white, '♛'.colorize(:white)
    include_examples 'a queen', :white, '♛'.colorize(:white)
  end

  describe 'black queen' do
    include_examples 'a chess piece', 'queen', :black, '♛'.colorize(:black)
    include_examples 'a queen', :black, '♛'.colorize(:black)
  end
end
