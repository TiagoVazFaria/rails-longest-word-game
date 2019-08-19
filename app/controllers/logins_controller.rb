class LoginsController < ApplicationController
  def create
    @score = params[:score]
    cookies[:score] = @score
  end
end
