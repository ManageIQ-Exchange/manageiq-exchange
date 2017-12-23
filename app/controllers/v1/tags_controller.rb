module V1
  ##
  # Tags controller
  # Allows the API to show and modify tags
  #
  class TagsController < ApplicationController
    # before_action :authenticate_user!, only: [:create]

    def index
      logger.debug 'Returning tags index'
      @tags = Tag.where('name like ?', "%#{params[:query]&.parameterize}%" )
      if @tags.count.positive?
        return_response @tags, :ok, {}
      else
        render  status: :no_content
      end
    end

    def show
      logger.debug 'Returning tag @tag.name'
      @tag = Tag.find_by(name: params[:id])
      if @tag
        return_response  @tag, :ok, {}
      else
        render status: :not_found
      end
    end
  end
end
