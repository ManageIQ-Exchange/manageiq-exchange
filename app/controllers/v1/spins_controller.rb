module V1
  ###
  # Spins controller
  # Provides actions on the Spins
  #
  ##
  class SpinsController < ApiController
    before_action :authenticate_user!, only: [:refresh, :visible, :publish]
    ###
    # Index (search: string - optional )
    # Provides an index of all spins in the system
    # TODO If you provide a search team, it will return those spins mathing the search
    # TODO: Add paging
    # users/<user_id>/spins Get all spins of a user
    # spins?query=<value>  Look spins include value in the name
    def index
      if params[:user_id]
        @user = User.find_by_github_login(params[:user_id])
        unless @user
          return_response status: :no_content
          return
        end
        @spins = Spin.where(user_id: @user.id, visible: true ) if @user
      else
        @spins = Spin.where(visible:true)
      end
      @spins = @spins.where('name like? or name like?', "%#{params[:query]}%", "%#{params[:query].downcase}%") if params[:query]
      if @spins.count.positive?
        return_response @spins, :ok, {}
      else
        render status: :no_content
      end
    end

    ###
    # Show (id: identification of the spin)
    # Provides a view of the spin
    # TODO: When authenticated, provide extended info
    # users/<user_id>/spins/<spin_id_or_name> Get a specific spin of user
    def show
      if params[:user_id]
        @user = User.find_by_github_login(params[:user_id])
        return_response status: :not_found unless @user
        @spin = Spin.find_by(user_id: @user.id, visible: true, id: params[:id]) || Spin.find_by(user_id: @user.id, visible: true, name: params[:id])
      else
        @spin = Spin.find_by(id: params[:id], visible: true) || Spin.find_by(name: params[:id], visible: true)
      end
      unless @spin
        render_error_exchange(:spin_not_found, :not_found)
        return
      end
      return_response  @spin,  :ok, {}
    end

    ###
    # Refresh
    # Authenticated only
    # Refresh the list of providers for the user.
    # Connects to github, gets all repos of the user, and search for spins
    #
    def refresh
      user = current_user.admin? ? User.find(params[:user_id]) : current_user
      if user.nil?
        render json: { error: 'No user found' }, status: :not_found
        return
      end
      job = RefreshSpinsJob.perform_later(user: user, token: request.headers['HTTP_X_USER_TOKEN'])
      render json: { data: job.job_id, metadata: { queue: job.queue_name, priority: job.priority } }, status: :accepted
    end

    def visible
      return unless  check_params_required(:spin_id, :flag)
      spin = Spin.find_by(id:params[:spin_id])
      if spin
        if spin.belongs_to?(current_user)
          if spin.visible_to(true?(params[:flag]))
            return_response spin, :accepted, {}
          else
            render_error_exchange(:spin_not_published, :method_not_allowed)
          end
        else
          render_error_exchange(:spin_not_owner, :unauthorized)
        end
      else
        render_error_exchange(:spin_not_found, :not_found)
      end
    end

    def publish
      return unless  check_params_required(:spin_id, :flag)
      spin = Spin.find_by(id:params[:spin_id])
      if spin
        if spin.belongs_to?(current_user)
          if spin.publish_to( @current_user, true?(params[:flag]))
            return_response spin, :accepted, {}
          else
            render_error_exchange(:spin_not_published, :method_not_allowed, spin.log)
          end
        else
          render_error_exchange(:spin_not_owner, :unauthorized)
        end
      else
        render_error_exchange(:spin_not_found, :not_found)
      end
    end
  end
end
