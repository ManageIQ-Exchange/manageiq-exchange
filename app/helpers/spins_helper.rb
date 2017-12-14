require 'base64'
require 'github/markup'
require 'json-schema'

###
# SCHEMA defines the schema to be used in the metadata.yml file
#
SPIN_SCHEMA = Rails.application.config.spin_schema.freeze
###
# Helper methods for Spins
#
##
module SpinsHelper
  include SourceControlHelper
  ####
  # spin_metadata (full name of repo to be analyzed)
  # Analizes the metadata and returns it
  #   when the format is correct
  #
  # @param full_name [String] Full name of repo
  # @return [metadata: String, metadata_json: JSON, readme: String]
  def spin_metadata(full_name)
    mtd, mtd_json = source_control_server.metadata(full_name)
    rdm = source_control_server.readme(full_name)
    return [mtd, mtd_json, rdm] if mtd && rdm
    false
  end
end
