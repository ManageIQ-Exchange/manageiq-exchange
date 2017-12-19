module V1
  ##
  # Tags controller
  # Allows the API to show and modify tags
  #
  class TagsController < ApplicationController
    # before_action :authenticate_user!, only: [:create]

    def index
      logger.debug 'Returning tags index'
      @tags = Tag.where('name like ?', "%#{params[:query]}%" )

      return_response json: @tags, status: :ok
    end

    def show
      logger.debug 'Returning tag @tag.name'
      @tag = Tag.find_by(name: params[:id])
      return_response json: @tag, status: :ok
    end
  end
end
