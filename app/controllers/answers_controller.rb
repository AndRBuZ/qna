class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy update]
  before_action :find_questions, only: %i[create]
  before_action :find_answer, only: %i[destroy update best]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    @answer.update(answer_params)
  end

  def destroy
    @answer.destroy
  end

  def best
    @question = @answer.question
    @answer.mark_as_best if current_user.author_of?(@question)
  end

  private

  def find_questions
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [])
  end
end
