###
# Spin Class
#
# Spin(id: integer,
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
#     updated_at: datetime)
#
class Spin < ApplicationRecord
  belongs_to :user
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  include SourceControlHelper

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
  def publish?
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
  def spin_of?(target_user)
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
    if publish?
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
  def publish_to(flag = true)
    if flag
      validate_spin? ? update(published: flag) : (return false)
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
    update(log:log)
  end

  # Validate if the spin is ok or not
  #
  # == Returns:
  # A boolean representing if the spin is validated or not
  #
  def validate_spin?
    validate_readme? && validate_metadata?
  end

  # Validate readme
  #
  # == Returns:
  # A boolean representing if the spin readme is ok
  #
  def validate_readme?
    rdm = source_control_server.readme(full_name)
    if rdm
      update(readme: rdm)
      return true
    else
      spin_log("Error getting README from GitHub")
    end
    false
  end

  # Validate metadata
  #
  # == Returns:
  # A boolean representing if the spin metadata is ok
  #
  def validate_metadata?
    metadata_raw = source_control_server.metadata(full_name)
    if metadata_raw
      begin
        metadata_json = JSON.parse(JSON.dump(YAML.safe_load(metadata_raw)))
        unless metadata_json.nil?
          JSON::Validator.validate!(SPIN_SCHEMA, metadata_json)
          update(metadata: metadata_json, metadata_raw: metadata_raw)
          return true
        end
        spin_log("Error parsing metadata to JSON, result is nil")
      rescue TypeError, JSON::ParserError, JSON::Schema::ValidationError => e
        spin_log("Error in metadata when #{e.class} error: #{e.to_string}")
      end
    else
      spin_log("Error getting metadata from GitHub")
    end
    false
  end
end
