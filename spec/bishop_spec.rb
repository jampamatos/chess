# frozen_string_literal: true

require_relative 'spec_helper'
require_relative '../lib/dependencies'

RSpec.describe Bishop do
  describe 'white bishop' do
    include_examples 'a chess piece', 'bishop', :white, '♝'.colorize(:white)
    include_examples 'a bishop', :white, '♝'.colorize(:white)
  end

  describe 'black bishop' do
    include_examples 'a chess piece', 'bishop', :black, '♝'.colorize(:black)
    include_examples 'a bishop', :black, '♝'.colorize(:black)
  end
end
