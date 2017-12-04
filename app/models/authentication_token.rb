##
# AuthenticationToken
# Class to store the Authentication Token for the user
# AuthenticationToken(id: integer,
#                     body: string,
#                     user_id: integer,
#                     last_used_at: datetime,
#                     ip_address: string,
#                     user_agent: string,
#                     created_at: datetime,
#                     updated_at: datetime)
##
class AuthenticationToken < ApplicationRecord
  belongs_to :user
end
