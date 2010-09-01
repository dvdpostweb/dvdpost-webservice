class MoviesController < ApplicationController

  def show
    @movie = Movie.find(params[:id])
    #token = Token.create(:ip          => request.remote_ip,
    #                     :expires_at  => 1.day.from_now,
    #                     :filename    => @movie.filename)
    token = Token.find(63)
    @token = token.token
  end
end
