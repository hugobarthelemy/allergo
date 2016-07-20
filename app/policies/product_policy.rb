class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def show?
    true
  end

  def update?
    true # tous les users signés peuvent editer
  end

  def create?
    true # tous les utilisateurs peuvent créer un user
  end

  def delete?
    false # seuls les admins peuvent deleter un produit
  end
end
