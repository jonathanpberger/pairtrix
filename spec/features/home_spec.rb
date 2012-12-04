require 'spec_helper'

describe "homepage" do
  it "displays the home page" do
    visit root_url

    within(".navbar.navbar-fixed-top") do
      expect(page).to have_css("a", text: "Sign in")
    end
  end
end
