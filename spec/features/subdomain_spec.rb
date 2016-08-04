require 'features_helper'

feature 'subdomains', :js do
  scenario "visit subdomains", :visual do
    visit questions_path
    expect(page).to match_reference_screenshot label: 'default'

    switch_subdomain('night')
    visit questions_path
    expect(page).to match_reference_screenshot label: 'night'
  end
end
