module V1
  ###
  # Spins controller
  # Provides actions on the Spins
  #
  ##
  class SpinsController < ApiController
    before_action :authenticate_user!, except: [:index, :show, :releases, :one_release, :download]
    ###
    # Index (search: string - optional )
    # Provides an index of all spins in the system
    # TODO If you provide a search team, it will return those spins mathing the search
    # TODO: Add paging
    # users/<user_id>/spins Get all spins of a user
    # spins?query=<value>  Look spins include value in the name
    def index
      @spins = Spin.where(visible:true)
      @spins = @spins.where("'name' ILIKE ?", "%#{params[:name]}%") if params[:name]
      @spins = @spins.joins(:user).where("users.github_login ILIKE ?", "%#{params[:author]}%") if params[:author]
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
      @spin = Spin.find_by(id: params[:id], visible: true) || Spin.find_by(name: params[:id], visible: true)
      unless @spin
        render_error_exchange(:spin_not_found, :not_found)
        return
      end
      return_response  @spin,  :ok, {}
    end

    def destroy
      # TODO
    end

    def releases
      @spin = Spin.find_by(id: params[:spin_id], visible: true) || Spin.find_by(name: params[:spin_id], visible: true)
      unless @spin
        render_error_exchange(:spin_not_found, :not_found)
        return
      end
      return_response @spin.releases, :ok, {}
    end

    def one_release
      @release = Release.find_by(id: params[:release_id], spin: params[:spin_id])
      unless @release
        render_error_exchange(:release_not_found, :not_found)
        return
      end
      return_response @release, :ok, {}
    end

    def download
      @release = Release.find_by(id: params[:release_id], spin: params[:spin_id])
      unless @release
        render_error_exchange(:release_not_found, :not_found)
        return
      end
      redirect_to @release.download_release
    end
  end
end
