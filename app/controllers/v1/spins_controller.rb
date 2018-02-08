module V1
  ###
  # Spins controller
  # Provides actions on the Spins
  #
  ##
  class SpinsController < ApiController
    before_action :authenticate_user!, except: [:index, :show]
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
      @spins = @spins.where('name ILIKE ?', "%#{params[:name]}%") if params[:name]
      @spins = @spins.joins(:user).where('users.github_login ILIKE ?', "%#{params[:author]}%") if params[:author]
      @spins = @spins.order("#{params[:sort]} #{params[:order] || 'DESC'}") if params[:sort]
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

    def destroy
      # TODO
    end
  end
end
