###
# __Background Job to refresh user spins__
# Will refresh all repos for a user and analyze them
# It will update them if found adfads
#
# @param  user: User
# @return boolean
#
class RefreshTagsJob < ApplicationJob

  queue_as :default

  def perform()
    logger.info "Refresh Tags Job"
    Tag.all.each do |tag|
      tag.delete unless tag.spins.present?
    end
  end
end


