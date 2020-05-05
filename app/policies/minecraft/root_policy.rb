module Minecraft
  class RootPolicy < ApplicationPolicy
    def index?
      true
    end

    def show?
      user.confirmed?
    end

    def create?
      user.confirmed?
    end

    def update?
      user.confirmed?
    end

    def destroy?
      user.admin?
    end
  end
end
