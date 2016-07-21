class LevelPolicy < ApplicationPolicy
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
    user == record.user
  end

  def destroy?
    user == record.user
  end
end
