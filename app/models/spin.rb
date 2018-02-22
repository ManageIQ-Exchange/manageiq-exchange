###
# Spin Class
#
# Spin
#     id: integer,
#     published: boolean,
#     name: string,
#     full_name: text,
#     description: text,
#     clone_url: string,
#     html_url: string,
#     issues_url: string,
#     forks_count: integer,
#     stargazers_count: integer,
#     watchers_count: integer,
#     open_issues_count: integer,
#     size: integer,
#     gh_id: string,
#     gh_created_at: datetime,
#     gh_pushed_at: datetime,
#     gh_updated_at: datetime,
#     gh_archived: boolean,
#     default_branch: string,
#     readme: text,
#     license_key: string,
#     license_name: string,
#     license_html_url: string,
#     version: string,
#     metadata: jsonb,
#     metadata_raw: text,
#     min_miq_version: integer,
#     first_import: datetime,
#     score: float,
#     user_id: integer,
#     company: text,
#     created_at: datetime,
#     updated_at: datetime
#
class Spin < ApplicationRecord
  belongs_to :user
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :releases, dependent: :destroy
  belongs_to :spin_candidate

  # Check if the spin is from the user
  #
  # == Parameters:
  # target_user::
  #   A User object
  #
  # == Returns:
  # A boolean representing if the spin owner is target_user
  #
  def belongs_to?(target_user)
    user == target_user
  end

  def scm_connection(user = @user)
    @scm_connection ||= Providers::BaseManager.new(user).get_connector
  end

  def check(user)
    @spin_log = ""
    scm_connection(user) # Initialize the connection
    repo = scm_connection.repo(full_name)
    metadata_raw, metadata_json = scm_connection.metadata(full_name)
    # We want all the data, not just the first one to fail
    valid_rdm  = has_valid_readme?
    valid_meta = has_valid_metadata?
    valid_rel = has_valid_releases?
    if valid_rdm && valid_meta && valid_rel
      self.name= repo.name,
      self.readme = readme,
      self.full_name= repo.full_name,
      self.description= repo.description,
      self.clone_url= repo.clone_url,
      self.html_url= repo.html_url,
      self.issues_url= "#{repo.html_url}/issues",
      self.forks_count= repo.forks_count,
      self.stargazers_count= repo.stargazers_count,
      self.watchers_count= repo.watchers,
      self.open_issues_count= repo.open_issues_count,
      self.size= repo.size,
      self.gh_id= repo.id,
      self.gh_created_at= repo.created_at,
      self.gh_pushed_at= repo.pushed_at,
      self.gh_updated_at= repo.updated_at,
      self.gh_archived= repo.archived,
      self.default_branch= repo.default_branch || 'master',
      self.license_key= repo.license&.key,
      self.license_name= repo.license&.name,
      self.license_html_url= repo.license&.url,
      self.version= metadata_json['spin_version'],
      self.min_miq_version= metadata_json['min_miq_version'].downcase.bytes[0] - 'a'.bytes[0],
      self.metadata = metadata_json
      self.metadata_raw = metadata_raw
      self.user_login = user.github_login
      self.downloads_count ||= 0
      if new_record?
        self.user = user
        self.name = self.name.gsub(/(\[\"|\"\])/, '').split('", "').first
      end
      if save
        refresh_releases(@releases)
        refresh_tags
        spin_log('[OK] Spin is validated')
        spin_candidate.update(validated: true, validation_log: @spin_log)
        return true
      end
    end
    spin_candidate.update(validated: false, validation_log: @spin_log)
    return false
  end

  # Update Log
  def spin_log(log)
    @spin_log ||= ''
    @spin_log = @spin_log + log + '\n'
  end

  # Validate release
  #
  # == Returns:
  # A boolean representing if the spin has releases
  #
  def has_valid_releases?
    @releases = scm_connection.releases(full_name) || []
    if @releases.empty? || @releases.kind_of?(ErrorExchange)
      spin_log('[ERROR] The Spin should have at least a release, please add it to the source control and refresh the Spin')
    else
      spin_log('[OK] The Spin has releases')
      return true
    end
    false
  end

  # Validate readme
  #
  # == Returns:
  # A boolean representing if the spin readme is ok
  #
  def has_valid_readme?
    readme = scm_connection.readme(full_name)
    if readme.blank? || readme.kind_of?(ErrorExchange)
      spin_log('[ERROR] The Spin should have a readme, please add it to the source control and refresh the Spin')
    else
      spin_log('[OK] The Spin has a readme')
      return true
    end
    false
  end

  # Validate metadata
  #
  # == Returns:
  # A boolean representing if the spin metadata is ok
  #
  def has_valid_metadata?
    meta = scm_connection.metadata(full_name)
    if meta.blank? || meta.kind_of?(ErrorExchange)
      spin_log('[ERROR] Error parsing metadata')
    else
      spin_log('[OK] The Spin metadata is correct')
      return true
    end
    false
  end
  # Refresh tags of spin
  # TODO: add tags from GitHub
  #
  # == Returns
  # Nothing
  # == Logs
  # tags added + validation in the spin
  #
  def refresh_tags
    taggings.delete_all
    metadata['tags'].each do |tag|
      new_tag = Tag.find_or_create_by(name: tag.parameterize)
      tags << new_tag
      validation = new_tag.find_similar
      spin_log(validation) unless validation.nil?
    end
  end

  def refresh_releases(data)
     data.each do |rele|
       new_release = Release.find_by(id: rele["id"], spin: self) || Release.new(id: rele["id"], spin: self)
       new_release.draft        = rele["draft"],
       new_release.tag          = rele["tag_name"],
       new_release.name         = rele["name"],
       new_release.prerelease   = rele["prerelease"],
       new_release.created_at   = rele["created_at"],
       new_release.published_at = rele["published_at"],
       new_release.zipball_url  = rele["zipball_url"],
       new_release.author       = {
         login: rele["author"]["login"],
         id: rele["author"]["id"],
         url: rele["author"]["html_url"],
         avatar_url: rele["author"]["avatar_url"]
       }
       new_release.save
     end
  end
end
