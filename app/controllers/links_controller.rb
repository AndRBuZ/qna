class LinksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_link

  def destroy
    @link.delete
  end

  private

  def set_link
    @link = Link.find(params[:id])
  end
end
