module OmniauthMacros
  def mock_auth_hash
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      provider: 'facebook', 
      uid: '123456',
      info: {email: 'user@email.com'} })       
  end

  def invalid_credentials
    OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
  end
end
