class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!, only: %i[create destroy update upvote downvote]
  before_action :find_question, only: %i[create]
  before_action :find_answer, only: %i[destroy update best]

  after_action :publish_answer, only: [:create]

  authorize_resource

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

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[name url _destroy],
                                          award_attributes: %i[title image])
  end

  def publish_answer
    return if @answer.errors.any?

    answer = {
      answer_id: @answer.id,
      user_id: @answer.user_id,
      answer_body: @answer.body,
      links: @answer.links.map { |link| { name: link.name, id: link.id, url: link.url } },
      files: @answer.files.map { |file| { url: file.url, name: file.filename, id: file.id } },
      votes: @answer.result_rating
    }

    ActionCable.server.broadcast(
      "questions_#{@question.id}_answers",
      ApplicationController.render(
        json: answer
      )
    )
  end
end
