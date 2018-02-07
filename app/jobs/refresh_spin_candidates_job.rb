###
# __Background Job to refresh user Spin Candidates__
# Will refresh all repos for a user and analyze them
# It will update them if found adfads
#
# @param  user: User
# @return boolean
#
class RefreshSpinCandidatesJob < ApplicationJob

  queue_as :default

  def perform(user:, token:)
    logger.info "Refresh Spin Candidates Job for user: #{user.id}"
    # Get the client using the application id (only public information)
    #
    client = Providers::BaseManager.new(user).get_connector
    # Find the spins in the database, store them as an array
    user_spin_candidates = user.spin_candidates
    app_token = Tiddle::TokenIssuer.build.find_token(user, token)
    client.github_access.access_token = app_token.github_token
    user_spin_candidates_list = user_spin_candidates.map(&:id)
    # Get the list of repos in GitHub (they use the same id in github and local) for the user
    repos = client.repos
    repos_list = repos.map(&:id)
    # List of deleted repos
    deleted_repos = user_spin_candidates_list - repos_list
    # Delete deleted repos
    Spin.where(id: deleted_repos).destroy_all
    # For each repo:
    # Verify that the repo has the file marking is as a candidate
    # See if the repo is already in the database
    # If it is in the database, update it
    # If it is not in the database, add it to the database
    repos.each do |repo|
      spin_candidate = user_spin_candidates_list.include?(repo.id) ?
                           SpinCandidate.find_by(id: repo.id) :
                           SpinCandidate.new(id: repo.id,
                                             full_name: repo.full_name,
                                             user: user,
                                             validation_log: "Pending validation")
      if (spin_candidate.is_candidate? user: user)
        spin_candidate.save
      else
        spin_candidate.destroy unless spin_candidate.new_record?
      end
    end
  end
end
