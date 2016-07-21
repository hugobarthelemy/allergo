class Level < ActiveRecord::Base
  belongs_to :user
  belongs_to :allergy
  validates :allergy, uniqueness: { scope: :user }

  def new
    @level = Level.new
    authorize @level
  end

end
