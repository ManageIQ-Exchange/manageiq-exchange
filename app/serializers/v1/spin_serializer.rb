module V1
  class SpinSerializer < ApplicationSerializer
    has_one :user, serializer: UserSerializer
    has_many :releases, serializer: ReleaseSerializer
  end
end
