shared_examples_for 'authorization can be create' do
  it 'creates new user' do
    expect { User.find_for_oauth(auth, user_email) }.to change(User, :count).by(1)
  end

  it 'creates confirmed user' do
    expect(User.find_for_oauth(auth, user_email).confirmed?).to eq true
  end

  it 'returns new user' do
    expect(User.find_for_oauth(auth, user_email)).to be_a(User)
  end

  it 'creates authorization with provider and uid' do
    authorization = User.find_for_oauth(auth, user_email).authorizations.first
    expect(authorization.provider).to eq auth.provider
    expect(authorization.uid).to      eq auth.uid
  end
end
