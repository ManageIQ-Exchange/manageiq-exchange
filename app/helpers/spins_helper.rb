require 'base64'
require 'github/markup'
require 'json-schema'

###
# SCHEMA defines the schema to be used in the metdata.yml file
#
SCHEMA = { "title": 'spin_doctor',
           "description": 'This is the schema for the spin metadata',
           "type": 'object',
           "properties": {
             "min_miq_version": {
               "type": 'string',
               "pattern": '^[a-z]$'
             },
             "spin_version": {
               "type": 'string',
               "pattern": '^\d+\.\d+\.\d+$'
             },
             "author": {
               "type": 'string'
             },
             "company": {
               "type": %w[string null]
             },
             "license": {
               "type": 'string'
             },
             "tags": {
               "type": 'array',
               "items": {
                 "type": 'string'
               }
             }
           },
           "required": %w[min_miq_version spin_version author license tags] }.freeze
###
# Helper methods for Spins
#
#
module SpinsHelper
  ####
  # spin_metadata (full name of repo to be analyzed)
  # Analizes the metadata and returns it
  # When the format is correct
  def spin_metadata(full_name)
    mtd, mtd_json = gh_metadata(full_name)
    rdm = gh_readme(full_name)
    return [mtd, mtd_json, rdm] if mtd && rdm
    false
  end

  ###
  # Access the metadata from a repo (looking for the file /metadata.yml)
  #
  def gh_metadata(full_name)
    begin
      metadata_raw = gh_client.contents(full_name, path: '/metadata.yml', accept: 'application/vnd.github.raw')
    rescue Octokit::NotFound
      nil
    end

    begin
      metadata_json = JSON.parse(JSON.dump(YAML.safe_load(metadata_raw)))
      JSON::Validator.validate!(SCHEMA, metadata_json)
      [metadata_raw, metadata_json]
    rescue JSON::ParserError
      nil
    end
  end

  ###
  # Gets the readme of the repo
  #
  def gh_readme(full_name)
    gh_client.readme(full_name, accept: 'application/vnd.github.raw')
  rescue Octokit::NotFound
    nil
  end

  ###
  # Function to connect to github
  #
  private def gh_client
    # Use session parameters to get access token
    @client ||= Octokit::Client.new client_id: Rails.application.secrets.oauth_github_id, client_secret: Rails.application.secrets.oauth_github_secret
  end
end
