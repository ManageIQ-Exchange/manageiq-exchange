module V1
  ##
  # Admin controller
  # Provides admin operations
  ##
  class AdminController < ApplicationController
    before_action :authenticate_user!
    before_action :authenticate_admin!

    def authenticate_admin!
      render json: {error: "You need be an administrator"}, status: :method_not_allowed unless current_user.admin?
    end

    # Refresh all users
    def users_refresh
      job = RefreshUsersJob.perform_later()
      render json: { data: job.job_id, metadata: { queue: job.queue_name, priority: job.priority } }, status: :accepted
    end

    # Set admin or staff or user
    ROLES_ACCEPTED= %w[staff admin user]
    def user_set_role
      @user = User.find_by(id: params[:id]) || User.find_by(github_login: params[:id])
      if ROLES_ACCEPTED.include? params[:role].downcase
        @user.set_role(params[:role])
        render status: :accepted
      else
        render json: {error: "You need to set a staff,admin or user role"}, status: :not_acceptable
      end
    end
  end
end
