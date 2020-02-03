class AnswersController < ApplicationController
  def index
  end

  def new
    @answer = Answer.new
  end

  def create
    @answer = Answer.new(answer_params)
    if @answer.save
      respond_to do |format|
        format.html { redirect_to word_path(@word) }
        format.js
      end
    else
      respond_to do |format|
        format.html { render 'words/show' }
        format.js
      end
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:user_description, :word)
  end

  def set_word
    @word = Word.find(params[:word_id])
  end
end
