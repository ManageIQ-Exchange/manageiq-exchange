module V1
  ##
  # Tags controller
  # Allows the API to show and modify tags
  #
  class TagsController < ApplicationController
    before_action :authenticate_user!, only: [:show]

    def index
      @tags = Tag.all
      render json: { data: @tags }, status: :ok
    end

    def show
      @tag = Tag.find_by(name: params[:id])
      render json: { data: @tag }, status: :ok
    end
  end
end
