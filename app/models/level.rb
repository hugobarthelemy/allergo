class Level < ActiveRecord::Base
  belongs_to :user
  belongs_to :allergy
end
