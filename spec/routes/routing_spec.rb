require "rails_helper"

RSpec.describe "routes to the ticket controller", :type => :routing do
  it { expect(:get => root_path).
        to route_to(:controller => "ticket", :action => "index") }
end

RSpec.describe 'ticket/index.html.haml', :type => :view do
  before { @departments = {"0" => 'first'} }

  it 'should have fields' do
    render
    expect(response.body).to match /Name:/
    expect(response.body).to match /Email:/
    expect(response.body).to match /Department:/
    expect(response.body).to match /Your request:/
  end
end
