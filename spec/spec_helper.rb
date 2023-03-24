# frozen_string_literal: true

require_relative 'support/chess_pieces_helper'
require_relative '../lib/dependencies'

RSpec.configure do |config|
  config.include ChessPiecesHelper
end
