shared_examples_for "API Successable" do
  before { do_request(access_token: access_token.token) }

  it 'returns 200 status' do
    expect(response).to be_success
  end
end
