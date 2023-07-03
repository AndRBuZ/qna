class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_question
  before_action :set_answer, only: [:show, :update, :destroy]

  authorize_resource class: Answer

  def index
    @answers = @question.answers
    render json: @answers, each_serializer: Api::V1::AnswersSerializer
  end

  def show
    render json: @answer
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_resource_owner
    if @answer.save
      head :ok
    else
      render json: @answer.errors.messages
    end
  end

  def update
    if @answer.update(answer_params)
      head :ok
    else
      render json: @answer.errors.messages
    end
  end

  def destroy
    if @answer.destroy
      head :ok
    else
      render json: @answer.errors.message
    end
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params['id'])
  end

  def answer_params
    params.require(:answer).permit(:body, :question_id, :user_id, links_attributes: %i[name url])
  end
end
