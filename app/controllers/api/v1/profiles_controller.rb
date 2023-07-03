class Api::V1::ProfilesController < Api::V1::BaseController
  authorize_resource class: User
  def me
    render json: current_resource_owner
  end

  def index
    @profiles = User.where("id != #{current_resource_owner.id}")
    render json: @profiles, each_serializer: Api::V1::ProfilesSerializer
  end
end
