require "rails_helper"

RSpec.describe Department, :type => :model do
  let!(:department) { FactoryGirl.build(:department) }

  it "should create and delete department" do
    expect { department.save }.to change(Department, :count)
    expect { department.delete }.to change(Department, :count)
  end

end