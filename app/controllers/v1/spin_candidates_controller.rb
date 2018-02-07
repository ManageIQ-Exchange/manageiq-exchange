module V1
  ###
  # Spin Candidates controller
  # Provides actions on the Spin Candidates
  #
  ##
  class SpinCandidatesController < ApiController
    before_action :authenticate_user! # Only authenticated values are valid

    ###
    # Index (search: string - optional )
    # Provides an index of all spins in the system
    # TODO If you provide a search team, it will return those spins mathing the search
    # users/<user_id>/spins Get all spins of a user
    # spins?query=<value>  Look spins include value in the name
    def index
      if params[:user_id]
        @user = User.find_by_github_login(params[:user_id])
        unless @user
          return_response status: :no_content
          return
        end
        @spins = SpinCandidate.where(user_id: @user.id) if @user
      else
        @spins = SpinCandidate.all
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
    # Provides a view of the Spin Candidate
    #
    # @params id: integer id of the spin candidate
    def show
      @spin = SpinCandidate.find_by(user_id: current_user.id, id: params[:id])
      unless @spin
        render_error_exchange(:spin_candidate_not_found, :not_found)
        return
      end
      return_response @spin, :ok, {}
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
      job = RefreshSpinCandidatesJob.perform_later(user: user, token: request.headers['HTTP_X_USER_TOKEN'])
      render json: { data: job.job_id, metadata: { queue: job.queue_name, priority: job.priority } }, status: :accepted
    end

    # Validates the SpinCandidate
    # @returns true | false
    # updates the log
    def validate
      # Create Spin with metadata
      # Validate the Spin
      # Write result in log
      # Return true or false
      sc = SpinCandidate.find(params[:spin_candidate_id])
      render_error_exchange(:spin_not_owner, :not_allowed) unless @current_user == sc.user

      # TODO test sc
      spin = sc.spin || Spin.new(full_name: sc.full_name, user: sc.user,)
      if(spin.check current_user)
        return_response sc, :ok, {}
      else
        render_error_exchange(:spin_candidate_not_validated, :not_found, {log: sc.validation_log})
      end
    end

    # Publish the SpinCandidate into a Spin
    # @returns :ok or :error
    def publish
      sc = SpinCandidate.find(params[:spin_candidate_id])
      if sc.validated
        if sc.publish_spin @current_user
          return_response sc, :ok, {}
        end
      else
        render_error_exchange(:spin_candidate_not_validated, :not_found, {log: sc.validation_log})
      end
      # If valid create or update the Spin
      # If not valid, the log should be updated.
    end
  end
end
