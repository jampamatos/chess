# frozen_string_literal: true

require_relative 'spec_helper'
require_relative '../lib/dependencies'

RSpec.describe Knight do
  describe 'white knight' do
    include_examples 'a chess piece', 'knight', :white, '♞'.colorize(:white)
    include_examples 'a knight', :white, '♞'.colorize(:white)
  end

  describe 'black knight' do
    include_examples 'a chess piece', 'knight', :black, '♞'.colorize(:black)
    include_examples 'a knight', :black, '♞'.colorize(:black)
  end
end
