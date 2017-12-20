###
# __Background Job to refresh user spins__
# Will refresh all repos for a user and analyze them
# It will update them if found adfads
#
# @param  user: User
# @return boolean
#
class RefreshUsersJob < ApplicationJob
  include SourceControlHelper

  queue_as :default

  def perform()
    logger.info "Refresh Users"
    # Get the client using the application id (only public information)
    # Find the spins in the database, store them as an array
    User.all.each do |user|
      data = Octokit.user user.github_login
      user.update(
              followers:data.followers,
              public_repos: data.public_repos
      )
    end
  end
end
