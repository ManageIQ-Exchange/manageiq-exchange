###
# Source Control Helper
# Helper to address the need to isolate the connection from the actual API calls
#
#
module SourceControlHelper
  # Creates an instance access_control_server to be reused by the application
  # @return [SourceControlServer]
  def source_control_server(provider_name)

    @source_control_server ||= GithubClient.new
  end
end
