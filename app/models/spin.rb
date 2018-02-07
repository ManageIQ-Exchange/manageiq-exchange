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

  # A JSON Schema to check the format of the metadata file
  SPIN_SCHEMA = Rails.application.config.spin_schema.freeze

  # Set spin log
  #
  # == Parameters:
  # log::
  #   A Text with the value of a log
  #
  def spin_log(new_log)
    log ||= ''
    log << new_log << "\n"
  end

  # Clean spin log
  #
  # == Parameters:
  #
  def clean_log
    log = ''
  end

  # Validate if the spin is ok or not
  #
  # == Returns:
  # A boolean representing if the spin is validated or not
  #
  def acceptable?(user)
    clean_log
    update_values(user)
    has_valid_readme?(user) && has_valid_metadata?(user) && has_valid_releases?(user)
    valid?
  end

  def update_values(user)
    byebug
    repo = Providers::BaseManager.new(user.authentication_tokens.first.provider).get_connector.readme(full_name)
    spin.name = repo.name
    spin.            full_name: repo.full_name,
                description: repo.description,
                clone_url: repo.clone_url,
                html_url: repo.html_url,
                issues_url: repo.rels[:issues].href,
                forks_count: repo.forks_count,
                stargazers_count: repo.stargazers_count,
                watchers_count: repo.watchers,
                open_issues_count: repo.open_issues_count,
                size: repo.size,
                gh_id: repo.id,
                gh_created_at: repo.created_at,
                gh_pushed_at: repo.pushed_at,
                gh_updated_at: repo.updated_at,
                gh_archived: repo.archived,
                default_branch: repo.default_branch || 'master',
                license_key: repo.license&.key,
                license_name: repo.license&.name,
                license_html_url: repo.license&.url,
                version: metadata_json['spin_version'],
                min_miq_version: metadata_json['min_miq_version'].downcase.bytes[0] - 'a'.bytes[0],
                releases: releases,
                user: current_user,
                user_login: current_user.github_login)
  end

  # Validate release
  #
  # == Returns:
  # A boolean representing if the spin has releases
  #
  def has_valid_releases?(user)
    update_releases(user)
    if releases.empty?
      spin_log('[ERROR] The Spin should have at least a release, please add it to the source control and refresh the Spin')
    else
      spin_log('[INFO] Releases found')
      return true
    end
    false
  end

  # Validate readme
  #
  # == Returns:
  # A boolean representing if the spin readme is ok
  #
  def has_valid_readme?(user)
    rdm = Providers::BaseManager.new(user.authentication_tokens.first.provider).get_connector.readme(full_name)
    if rdm
      update(readme: rdm)
      spin_log('[INFO] Readme found')
      return true
    else
      spin_log('[ERROR] The Spin should have a readme, please add it to the source control and refresh the Spin')
    end
    false
  end

  # Validate metadata
  #
  # == Returns:
  # A boolean representing if the spin metadata is ok
  #
  def has_valid_metadata?(user)
    metadata = Providers::BaseManager.new(user.authentication_tokens.first.provider).get_connector.metadata(full_name)
    if metadata.kind_of? ErrorExchange
      spin_log("[ERROR] Metadata error")
      spin_log("#{metadata.as_json["title"]} \n #{metadata.as_json["detail"]}")
    else
      update(metadata: metadata.second, metadata_raw: metadata.first)
      spin_log('[INFO] Validated metadata')
      return true
    end
    false
  end

  # Update releases
  #
  # == Returns:
  # A boolean representing if the spin releases are updated
  #
  def update_releases(user)
    releases = Providers::BaseManager.new(user.authentication_tokens.first.provider).get_connector.releases(full_name)
    return false unless releases
    update(releases: releases)
    true
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
