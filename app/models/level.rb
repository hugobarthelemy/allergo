class Level < ActiveRecord::Base
  belongs_to :user
  belongs_to :allergy
  def new
    @level = Level.new
    authorize @level
  end
end
