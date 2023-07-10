class SearchController < ApplicationController
  before_action :set_params

  def search
    @result = Search.new(@query, @scope, @page).call
    render partial: 'search/result'
  end

  private

  def set_params
    @scope = params[:scope] || 'all'
    @query = params[:query].to_s
    @page = params[:page]
  end
end
