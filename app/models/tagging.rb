###
# Tagging class
#
# A class that associates spins to tags
# Tagging(id: integer,
#         spin_id: integer,
#         tag_id: integer,
#         created_at: datetime,
#         updated_at: datetime)
# #
class Tagging < ApplicationRecord
  belongs_to :tag
  belongs_to :spin
end
