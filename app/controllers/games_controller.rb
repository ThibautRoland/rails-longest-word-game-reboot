require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    @start_time = Time.now
    10.times do
      @letters << ('A'..'Z').to_a.sample
    end
  end

  def score
    @end_time = Time.now
    @attempt = params[:word]
    @grid = params[:letters].split
    @game_time = @end_time - Time.parse(params[:start_time])
    url = "https://wagon-dictionary.herokuapp.com/#{@attempt}"
    user_serialized = URI.open(url).read
    user = JSON.parse(user_serialized)
    @result = {}
    if user["found"] && included?(@grid, @attempt)
      @result[:score] = ((@attempt.length * 1000)/@game_time).round
      @result[:message] = "well done"
    elsif user["found"] == false && included?(@grid, @attempt)
      @result[:score] = 0
      @result[:message] = "not an english word"
    else
      @result[:score] = 0
      @result[:message] = "Your word is not in the grid you moron!"
    end
  end

  def included?(letters, attempt)
    attempt.upcase.chars.each do |letter|
      if letters.include?(letter)
        letters.delete_at(letters.index(letter))
      else
        return false
      end
    end
    return true
  end
end
