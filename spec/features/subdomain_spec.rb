feature 'subdomains', :js do
  fscenario "visit subdomains", :visual do
    visit questions_path
    expect(page).to match_reference_screenshot label: 'default'

    switch_subdomain('night')
    visit questions_path
  visit_server wait: 0
    expect(page).to match_reference_screenshot label: 'night'
  end
end
