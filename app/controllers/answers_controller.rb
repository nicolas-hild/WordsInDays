class AnswersController < ApplicationController
  def index
  end

  def new
    @answer = Answer.new
  end

  def create
    @answer = Answer.new(answer_params)
    @answer.word_id = @answer.word_id.to_i
    @word = Word.find(@answer.word_id)
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
    params.require(:answer).permit(:user_definition, :word_id)
  end
end
