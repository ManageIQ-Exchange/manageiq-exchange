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

  def check(user)
    @spin_log = ""
    if update_values user
      if has_valid_readme? &&
          has_valid_metadata? &&
          has_valid_releases?
        if new_record?
          spin_candidate.update(validated: true, validation_log: "[OK] Spin is validated")
          return true
        else
          if save
            refresh_tags
            spin_candidate.update(validated: true, validation_log: "[OK] Spin is validated")
            return true
          end
        end
      end
    end
    spin_candidate.update(validated: false, validation_log: @spinlog)
    return false
  end

  def update_values(user)
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
    self.name= repo.name,
    self.readme = readme,
    self.full_name= repo.full_name,
    self.description= repo.description,
    self.clone_url= repo.clone_url,
    self.html_url= repo.html_url,
    self.issues_url= repo.rels[:issues].href,
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
    self.releases= go_json(releases),
    self.user= user,
    self.user_login= user.github_login
    self.downloads_url = ''
    true
  end

  # Update Log
  def spin_log(log)
    @spin_log = (@spin_log || '')+ '\n' + log
  end

  # Validate release
  #
  # == Returns:
  # A boolean representing if the spin has releases
  #
  def has_valid_releases?
    (return true) unless releases.blank?
    spin_log('[ERROR] The Spin should have at least a release, please add it to the source control and refresh the Spin')
    false
  end

  # Validate readme
  #
  # == Returns:
  # A boolean representing if the spin readme is ok
  #
  def has_valid_readme?
    if readme.blank?
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
    if metadata.blank?
      spin_log("[ERROR] Metadata error")
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
      new_tag = Tag.find_or_create_by(name: tag.parameterize)
      tags << new_tag
      validation = new_tag.find_similar
      spin_log(validation) unless validation.nil?
    end
  end

  def go_json(data)
    releases = []
    data.each do |one_release|
      obj = {}
      one_release.each do |k,v|
        if k.to_s != "author"
          obj[k.to_s] = v
        else
          author_json = {}
          v.each do |kt,vt|
            author_json[kt.to_s] = vt
          end
          obj[k.to_s] = author_json
        end
      end
      releases.push(obj)
    end
    { "releases":releases }
  end

  def format_releases(id = nil)
    result = []
    releases.first["releases"].each do |rele|
      if id && id == rele["id"].to_s
        result = rele["zipball_url"]
        break;
      else
        result = result.push(
          {
              id:  rele["id"],
              draft: rele["draft"],
              tag: rele["tag_name"],
              name: rele["name"],
              prerelease: rele["prerelease"],
              created_at: rele["created_at"],
              published_at: rele["published_at"],
              author:{
                  login: rele["author"]["login"],
                  id: rele["author"]["id"],
                  url: rele["author"]["html_url"],
                  avatar_url: rele["author"]["avatar_url"]
              }
          }
        )
      end
    end
    result
  end

  def download_release(release_id)
    result = format_releases(release_id)
    if result.empty?
      return nil
    end
    result
  end
end
