class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable

  after_action :publish_comment, only: [:create]

  authorize_resource

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    @comment.save
  end

  private

  def set_commentable
    @commentable = Answer.find_by(id: params[:answer_id]) || Question.find_by(id: params[:question_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return if @comment.errors.any?

    comment = {
      comment_body: @comment.body,
      user_id: @comment.user_id,
      comment_id: @comment.id,
      commentable_id: @commentable.id,
      commentable_type: @commentable.class.name.underscore
    }

    question_id = if @commentable.instance_of?(::Question)
                    @commentable.id
                  else
                    @commentable.question.id
                  end

    ActionCable.server.broadcast(
      "comments_#{question_id}",
      ApplicationController.render(
        json: comment
      )
    )
  end
end
