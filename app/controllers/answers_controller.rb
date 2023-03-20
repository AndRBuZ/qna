class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  before_action :find_questions, only: %i[create]
  before_action :find_answer, only: %i[destroy]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      redirect_to question_path(@question), notice: "Your answer successfully created."
    else
      flash[:errors] = @answer.errors
      @errors = @answer.errors
      redirect_to question_path(@question)
    end
  end

  def destroy
    @answer.destroy
    redirect_to question_path(@answer.question), notice: 'Your answer was successfully deleted.'
  end

  private

  def find_questions
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
