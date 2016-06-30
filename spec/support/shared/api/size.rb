shared_examples_for "API Sizable" do |size, path|
  object_name = self.metadata[:full_description].split.first.singularize

  before { do_request(access_token: access_token.token) }

  it "returns proper amount of #{object_name.pluralize}" do
    expect(response.body).to have_json_size(size).at_path(path)
  end
end
