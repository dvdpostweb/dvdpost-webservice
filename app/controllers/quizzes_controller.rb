class QuizzesController < ApplicationController

  def index
    redirect_to quiz_path(:id => QuizzName.on_focus.to_param)
  end

  def show
    @quizz_name = QuizzName.find(params[:id])
    @previous_list = QuizzName.previous_list(4)
  end
  
end
