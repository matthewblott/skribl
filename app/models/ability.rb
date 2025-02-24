class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.present?

    # Users can manage their own notes
    can :manage, Note do |note|
      # Since each user has their own database, they can manage all notes in their database
      true
    end

    if user.has_role?(:admin)
      # Admins can do system-wide operations if needed
      can :manage, :all
    end
  end
end
