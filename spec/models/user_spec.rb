require "rails_helper"

RSpec.describe User, :type => :model do
  let!(:user) { FactoryGirl.build(:user) }

  it "should create and delete user" do
    expect { user.save }.to change(User, :count)
    expect { user.delete }.to change(User, :count)
  end
end