module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, :find_vote, only: %i[upvote downvote]
  end

  def upvote
    if !@vote.present?
      create_vote(:upvote)
    elsif @vote.present? && @vote.vote == 'upvote'
      @vote.destroy
      render_votable
    else
      @vote.destroy
      create_vote(:upvote)
    end
  end

  def downvote
    if !@vote.present?
      create_vote(:downvote)
    elsif @vote.present? && @vote.vote == 'downvote'
      @vote.destroy
      render_votable
    else
      @vote.destroy
      create_vote(:downvote)
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def find_vote
    @vote = @votable.votes.find_by(user: current_user)
  end

  def create_vote(action)
    @vote = @votable.votes.new(user: current_user, vote: action)

    respond_to do |format|
      if @vote.save
        format.json { render_votable }
      else
        format.json do
          render json: @vote.errors.messages, status: :unprocessable_entity
        end
      end
    end
  end

  def render_votable
    render json: { rating: @votable.result_rating, votable_id: @votable.id,
                   model: @vote.votable_type.underscore }
  end
end
