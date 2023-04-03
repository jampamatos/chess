# frozen_string_literal: true

require_relative 'spec_helper'
require_relative '../lib/dependencies'

RSpec.describe King do
  describe 'white king' do
    include_examples 'a chess piece', 'king', :white, '♚'.colorize(:white)
    include_examples 'a king', :white, '♚'.colorize(:white)
  end

  describe 'black king' do
    include_examples 'a chess piece', 'king', :black, '♚'.colorize(:black)
    include_examples 'a king', :black, '♚'.colorize(:black)
  end
end