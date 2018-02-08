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
      return_response @spin.format_releases, :ok, {}
    end

    def one_release
      @spin = Spin.find_by(id: params[:spin_id], visible: true) || Spin.find_by(name: params[:spin_id], visible: true)
      unless @spin
        render_error_exchange(:spin_not_found, :not_found)
        return
      end
      target_release = {}
      @spin.format_releases.each do |release|
        if release[:id].to_s ==  params[:release_id].to_s
          target_release = release
          break;
        end
      end
      if target_release.empty?
        render_error_exchange(:release_not_found, :not_found)
        return
      else
        return_response target_release, :ok, {}
      end
    end

    def download
      @spin = Spin.find_by(id: params[:spin_id], visible: true) || Spin.find_by(name: params[:spin_id], visible: true)
      unless @spin
        render_error_exchange(:spin_not_found, :not_found)
        return
      end
      download_url = @spin.download_release(params[:release_id].to_s)
      if download_url
        @spin.downloads_count += 1
        @spin.save
        redirect_to download_url
      else
        render_error_exchange(:release_not_found, :not_found)
      end
    end
  end
end
