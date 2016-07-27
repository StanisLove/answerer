shared_examples_for "API Containable" do |attributes, path, not_present = []|
  before { do_request(access_token: access_token.token) }

  attributes.each do |attr|
    it "Object at '#{path}' contains #{attr}" do
      expect(response.body).to be_json_eql(
        object.send(attr.to_sym).to_json
      ).at_path("#{path}#{attr}")
    end
  end

  not_present.each do |attr|
    it "doesn't contain #{attr}" do
      expect(response.body).not_to have_json_path("#{path}/#{attr}")
    end
  end
end
