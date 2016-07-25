class Level < ActiveRecord::Base
  belongs_to :user
  belongs_to :allergy
  validates :allergy, uniqueness: { scope: :user }

end
