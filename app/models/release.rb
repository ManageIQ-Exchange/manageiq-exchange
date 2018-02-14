###
# Release Class
#
# Release
#     TO DO

class Release < ApplicationRecord
  belongs_to :spin

  serialize :author, JSON

  def download_release
    spin.downloads_count+=1
    spin.save
    self.zipball_url
  end
end
