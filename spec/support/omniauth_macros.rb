module OmniauthMacros
  def mock_auth_hash
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
      provider: 'github',
      uid: '123545',
      info: { email: 'test@example.com' }
    )
  end

  def mock_auth_invalid
    OmniAuth.config.mock_auth[:github] = :credentials_are_invalid
  end
end
