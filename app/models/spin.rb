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

  def check user:
    @spin_log = ""
    if update_values user
      if has_valid_readme? &&
          has_valid_metadata? &&
          has_valid_releases?
        spin_candidate.update(validated: true, validation_log: "[OK] Spin is validated")
        save
        return true
      end
    end
    spin_candidate.update(validated: false, validation_log: @spinlog)
    return false
  end

  def update_values user:
    client = Providers::BaseManager.new(user).get_connector
    meta = client.metadata(full_name)
    readme = client.readme(full_name)
    releases = client.releases(full_name)
    repo = client.repo(full_name)

    metadata_raw, metadata_json = meta

    if meta.kind_of?(ErrorExchange) ||
       readme.kind_of?(ErrorExchange) ||
       releases.kind_of?(ErrorExchange) ||
       repo.kind_of?(ErrorExchange)
      [meta, readme, releases, repo].each do |error|
        spin_log("#{error.as_json["title"]} \n #{error.as_json["detail"]}") if error.kind_of?(ErrorExchange)
      end
      return false
    end
    # Store new values
    name= repo.name,
    readme = readme,
    full_name= repo.full_name,
    description= repo.description,
    clone_url= repo.clone_url,
    html_url= repo.html_url,
    issues_url= repo.rels[:issues].href,
    forks_count= repo.forks_count,
    stargazers_count= repo.stargazers_count,
    watchers_count= repo.watchers,
    open_issues_count= repo.open_issues_count,
    size= repo.size,
    gh_id= repo.id,
    gh_created_at= repo.created_at,
    gh_pushed_at= repo.pushed_at,
    gh_updated_at= repo.updated_at,
    gh_archived= repo.archived,
    default_branch= repo.default_branch || 'master',
    license_key= repo.license&.key,
    license_name= repo.license&.name,
    license_html_url= repo.license&.url,
    version= metadata_json['spin_version'],
    min_miq_version= metadata_json['min_miq_version'].downcase.bytes[0] - 'a'.bytes[0],
    metadata = metadata_json
    metadata_raw = metadata_raw
    releases= releases,
    user= user,
    user_login= user.github_login
  end

  # Update Log
  def spin_log(log)
    @spin_log = @spin_log + '\n' + log
  end

  # Validate release
  #
  # == Returns:
  # A boolean representing if the spin has releases
  #
  def has_valid_releases?
    (return true) unless releases.empty?
    spin_log('[ERROR] The Spin should have at least a release, please add it to the source control and refresh the Spin')
    false
  end

  # Validate readme
  #
  # == Returns:
  # A boolean representing if the spin readme is ok
  #
  def has_valid_readme?
    if readme.kind_of? ErrorExchange
      spin_log('[ERROR] The Spin should have a readme, please add it to the source control and refresh the Spin')
    else
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
    if metadata.kind_of? ErrorExchange
      spin_log("[ERROR] Metadata error")
      spin_log("#{metadata.as_json["title"]} \n #{metadata.as_json["detail"]}")
    else
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
      new_tag = Tag.find_or_create_by(name: tag)
      tags << new_tag
      validation = new_tag.find_similar
      spin_log(log + validation) unless validation.nil?
    end
  end
end
