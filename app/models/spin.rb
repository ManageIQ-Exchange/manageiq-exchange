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

  # A JSON Schema to check the format of the metadata file
  SPIN_SCHEMA = Rails.application.config.spin_schema.freeze

  # Show if the spin is visible or not
  #
  # == Returns:
  # A boolean representing if the spin is visible
  #
  def visible?
    visible
  end

  # Show if the spin is published or not
  #
  # == Returns:
  # A boolean representing if the spin is publish
  #
  def published?
    published
  end

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

  # Set spin visible to true or false
  #
  # == Parameters:
  # flag::
  #   A boolean with the value to the visible spin
  #
  # == Returns:
  # A boolean representing if the spin was updated with visible to flag or not
  #
  def visible_to(flag = true)
    if published?
      update(visible: flag)
      true
    else
      false
    end
  end

  # Set spin publish to true or false
  #
  # == Parameters:
  # flag::
  #   A boolean with the value to the publish spin
  #
  # == Returns:
  # A boolean representing if the spin was updated with publish to flag or not
  #
  def publish_to(user, flag = true)
    if flag
      acceptable?(user) ? update(published: flag) : (return false)
    else
      update(published: flag)
    end
    true
  end

  # Set spin log
  #
  # == Parameters:
  # log::
  #   A Text with the value of a log
  #
  def spin_log(log)
    update(log: log)
  end

  # Validate if the spin is ok or not
  #
  # == Returns:
  # A boolean representing if the spin is validated or not
  #
  def acceptable?(user)
    has_valid_readme?(user) && has_valid_metadata?(user) && has_valid_releases?
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
  def has_valid_readme?(user)
    rdm = Providers::BaseManager.new(user.authentication_tokens.first.provider).get_connector.readme(full_name)
    if rdm
      update(readme: rdm)
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
  #
  def refresh_tags
    tags.delete_all
    metadata['tags'].each do |tag|
      new_tag = Tag.find_or_create_by(name: tag)
      tags << new_tag
      validation = new_tag.find_similar
      spin_log(log + validation) unless validation.nil?
    end
  end
end
