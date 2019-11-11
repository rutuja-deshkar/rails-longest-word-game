require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word]
    @grid = params[:grid]
    if included?(@word, @grid)
      if english_word?(@word)
        @response = "Congratulations! #{@word} is a valid English word!"
      else
        @response = "Sorry but #{@word} doesn\'t seem to be a valid English word"
      end
    else
      @response = "Sorry but #{@word} can\'t be built out of #{@letters}"
    end
  end

  private

  def included?(guess, grid)
    guess.chars.all? do |letter|
      guess.count(letter) <= grid.count(letter)
    end
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
