class SpinCandidate < ApplicationRecord
  belongs_to :user

  def is_candidate?(client:)
    begin
      raise Octokit::NotFound if client.github_access.nil?
      if client.github_access.contents(full_name, path: '/.manageiq-spin')
        true
      end
    rescue Octokit::NotFound
      false
    end
  end

end
