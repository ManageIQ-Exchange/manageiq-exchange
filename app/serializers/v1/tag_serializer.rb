module V1
  class TagSerializer < ApplicationSerializer
    attribute :count_spins

    def count_spins
      object.taggings.count
    end
  end
end
