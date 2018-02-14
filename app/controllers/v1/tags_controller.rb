module V1
  ##
  # Tags controller
  # Allows the API to show and modify tags
  #
  class TagsController < ApiController
    # before_action :authenticate_user!, only: [:create]
=begin
  @api {get} /tags Request index of tags
  @apiVersion 1.0.0
  @apiName GetTags
  @apiPermission none
  @apiGroup Tags
  @apiSuccess {Object[]} data
  @apiSuccess {Integer} data.id ID of the tag
  @apiSuccess {String} data.name Tag name
  @apiSuccess {Date} data.created_at
  @apiSuccess {Date} data.updated_at
  @apiUse NoContent
  @apiSuccessExample {json} Success
{ "data":
    [
    {
       "id": 1,
       "name": "report",
       "created_at": "2018-01-26T12:18:11.959Z",
       "updated_at": "2018-01-26T12:18:11.959Z"
    },
    {
       "id": 2,
       "name": "playbook",
       "created_at": "2018-01-26T12:18:11.965Z",
       "updated_at": "2018-01-26T12:18:11.965Z"
    },
    {
       "id": 3,
       "name": "dialogue",
       "created_at": "2018-01-26T12:18:11.970Z",
       "updated_at": "2018-01-26T12:18:11.970Z"
    },
    {
        "id": 4,
        "name": "workflow",
        "created_at": "2018-01-26T12:18:11.974Z",
        "updated_at": "2018-01-26T12:18:11.974Z"
      }
   ]
}
=end
    def index
      logger.debug 'Returning tags index'
      @tags = Tag.where('name like ?', "%#{params[:query]&.parameterize}%" )
      if @tags.count.positive?
        return_response @tags, :ok, {}
      else
        render  status: :no_content
      end
    end
=begin
  @api {get} /tags/:id Request tag info
  @apiVersion 1.0.0
  @apiName GetTagInfo
  @apiPermission none
  @apiGroup Tags
  @apiParam {String} id Tag id or name
  @apiSuccess {Object} data
  @apiSuccess {Integer} data.id ID of the tag
  @apiSuccess {String} data.name Tag name
  @apiSuccess {Date} data.created_at
  @apiSuccess {Date} data.updated_at
  @apiUse NoContent
  @apiSuccessExample {json} Success
{
    "data": {
        "id": 1,
        "name": "report",
        "created_at": "2018-01-26T12:18:11.959Z",
        "updated_at": "2018-01-26T12:18:11.959Z"
    }
}
=end
    def show
      return unless  check_params_required(:id)
      logger.debug 'Returning tag @tag.name'
      @tag = Tag.find_by(name: params[:id]) || Tag.find_by(id: params[:id])
      if @tag
        return_response  @tag, :ok, {}
      else
        render_error_exchange(:tag_not_found, :not_found, { tag_id: params[:id]})
      end
    end
  end
end
=begin
  @api {get} /tags?query= Request search
  @apiVersion 1.0.0
  @apiName GetTagQuery
  @apiPermission none
  @apiGroup Tags
  @apiParam {String} [query?] Search parameter
  @apiSuccess {Object} data
  @apiSuccess {Integer} data.id ID of the tag
  @apiSuccess {String} data.name Tag name
  @apiSuccess {Date} data.created_at
  @apiSuccess {Date} data.updated_at
  @apiUse NoContent
  @apiSuccessExample {json} Success
{
    "data": {
        "id": 1,
        "name": "report",
        "created_at": "2018-01-26T12:18:11.959Z",
        "updated_at": "2018-01-26T12:18:11.959Z"
    }
}
=end