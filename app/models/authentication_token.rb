##
# AuthenticationToken
# Class to store the Authentication Token for the user
#
class AuthenticationToken < ApplicationRecord
  belongs_to :user
end
