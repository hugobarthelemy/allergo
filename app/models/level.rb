class Level < ActiveRecord::Base
  belongs_to :user
  belongs_to :allergy
  validates :allergy, uniqueness: { scope: :user }

  LEVELS = {
    "Strong Allergy" => "2",
    "Intolerance" => "1"
  }

end
