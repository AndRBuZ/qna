class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :set_question, only: %i[show update destroy]

  authorize_resource class: Question

  def index
    @questions = Question.all
    render json: @questions, each_serializer: Api::V1::QuestionsSerializer
  end

  def show
    render json: @question, serializer: Api::V1::QuestionSerializer
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_resource_owner

    if @question.save
      head :ok
    else
      render json: @question.errors.messages
    end
  end

  def update
    if @question.update(question_params)
      head :ok
    else
      render json: @question.errors.messages
    end
  end

  def destroy
    if @question.destroy
      head :ok
    else
      render json: @question.errors.message
    end
  end

  private

  def set_question
    @question = Question.find(params['id'])
  end

  def question_params
    params.require(:question).permit(:title, :body, :user_id, links_attributes: %i[name url])
  end
end
