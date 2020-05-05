module Wireguard
  class RootPolicy < ApplicationPolicy
    def index?
      user.confirmed?
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
