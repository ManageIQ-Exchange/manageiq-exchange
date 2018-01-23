module V1
  ##
  # Tags controller
  # Allows the API to show and modify tags
  #
  class TagsController < ApiController
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
      return unless  check_params_required(:id)
      logger.debug 'Returning tag @tag.name'
      @tag = Tag.find_by(name: params[:id])
      if @tag
        return_response  @tag, :ok, {}
      else
        render_error_exchange(:tag_not_found, :not_found, { tag_id: parans[:id]})
      end
    end
  end
end
