module V1
  ###
  # Spins controller
  # Provides actions on the Spins
  #
  ##
  class SpinsController < ApplicationController
    before_action :authenticate_user!, only: [:refresh]
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
        @spins = Spin.where(user_id: @user.id ) if @user
      else
        @spins = Spin.all
      end
      @spins = @spins.where('name like? or name like?', "%#{params[:query]}%", "%#{params[:query].downcase}%") if params[:query]
      if @spins.count.positive?
        return_response json: @spins, status: :ok
      else
        return_response status: :no_content
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
        @spin = Spin.where(user_id: @user.id)
        if @spin.exists?(id: params[:id])
          @spin = @spin.find(params[:id])
        else
          if @spin.exists?(name: params[:id])
            @spin = @spin.find_by(name: params[:id])
          else
            @spin = nil
          end
        end
      else
        @spin = Spin.find_by(id: params[:id])
      end
      unless @spin
        return_response status: :not_found
        return
      end
      return_response json: @spin, status: :ok
    end

    ###
    # Refresh
    # Authenticated only
    # Refresh the list of providers for the user.
    # Connects to github, gets all repos of the user, and search for spins
    #
    def refresh
      user = if current_user.admin?
               User.find(params[:user_id]) || current_user
             else
               current_user
             end
      if user.nil?
        render json: { error: 'No user found' }, status: :not_found
        return
      end
      job = RefreshSpinsJob.perform_later(user: user, token: request.headers['HTTP_X_USER_TOKEN'])
      return_response json: { data: job.job_id, metadata: { queue: job.queue_name, priority: job.priority } }, status: :accepted
    end
  end
end
