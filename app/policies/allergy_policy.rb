class AllergyPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def new?
    true
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

  def destroy?
    true
  end
end
