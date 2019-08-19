require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @alphabet = ('A'..'Z').to_a

    @letters = []
    @letters << @alphabet.sample while @letters.size < 10
    @letters
  end

  def score
    session[:score]
    @attempt = params[:word].upcase
    @letters = params[:letters].gsub(/\W/, '').chars



    url = "https://wagon-dictionary.herokuapp.com/#{@attempt}"
    serialized_response = open(url).read
    word = JSON.parse(serialized_response)
    @exists = word['found']

    grid_hash = Hash.new(0)
    @letters.each { |letter| grid_hash[letter] += 1 }
    attempt_hash = Hash.new(0)
    @attempt.upcase.chars.each { |letter| attempt_hash[letter] += 1 }
    grid_confirm = []
    @attempt.chars.each { |letter| grid_confirm << (grid_hash[letter.upcase] >= attempt_hash[letter.upcase]) }
    @letter_confirm = grid_confirm.include?(false) ? false : true

    session[:score] += @attempt.length if @exists && @letter_confirm
  end
end
