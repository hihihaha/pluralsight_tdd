require 'rails_helper'

RSpec.describe Achievement, type: :model do
  describe "validations" do
    it "requires title" do
      achievement = Achievement.new(title: "")
      expect(achievement.valid?).to be_falsy
    end

    it "requires title to be unique for one user" do
      user = FactoryGirl.create(:user)
      achievemnent = FactoryGirl.create(:public_achievement, title: "First Achievement", user: user)
      new_achievement = Achievement.new(title: "First Achievement", user: user)
      expect(new_achievement.valid?).to be_falsy
    end

    it "allows differnet users to have achievemnents with identical titles" do
      user_1 = FactoryGirl.create(:user)
      user_2 = FactoryGirl.create(:user)
      user_1_achievement = FactoryGirl.create(:public_achievement, title: "Achievement", user: user_1)
      user_2_achievement = Achievement.new(title: "Achievement", user: user_2)
      expect(user_2_achievement.valid?).to be_truthy
    end
  end
end
