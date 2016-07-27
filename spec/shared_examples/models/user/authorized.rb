shared_examples_for "may be authorized" do
  it "doesn't create new user" do
    expect { User.find_for_oauth(auth, user) }.not_to change(User, :count)
  end

  it 'returns the user' do
    expect(User.find_for_oauth(auth, user)).to eq user
  end

  it 'creates authorization for user' do
    expect do
      User.find_for_oauth(auth, user)
    end.to change(user.authorizations, :count).by(1)
  end

  it 'creates authorization with provider and uid' do
    user = User.find_for_oauth(auth, user)
    authorization = user.authorizations.first
    expect(authorization.provider).to eq auth.provider
    expect(authorization.uid).to      eq auth.uid
  end
end
