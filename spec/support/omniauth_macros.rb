module OmniauthMacros
  def mock_auth(provider, email = nil)
    auth_hash = {
      provider: provider.to_s,
      uid: '123545'
    }
    auth_hash.merge!(info: { email: email }) if email
    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new(auth_hash)
  end
end
