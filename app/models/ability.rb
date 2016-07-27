class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    alias_action :vote_up, :vote_down, :vote_reset, to: :vote

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  private

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create,             [Question, Answer, Comment]
    can [:update, :destroy], [Question, Answer], user: user

    can :choose_best, Answer do |answer|
      answer.question.user == user
    end
    can :vote, [Question, Answer] do |resource|
      resource.user != user
    end

    can :me, :profile

    can :create, Subscription do |subscription|
      !user.subscriptions.include?(subscription)
    end

    can :destroy, Subscription do |subscription|
      user.subscriptions.include?(subscription)
    end
  end
end
