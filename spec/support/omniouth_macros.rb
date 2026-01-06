module OmniauthMacros
  def mock_omniauth(provider, uid:, email:, name:)
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[provider.to_sym] = OmniAuth::AuthHash.new({
      provider: provider.to_s,
      uid: uid,
      info: {
        email: email,
        name: name
      }
    })
  end

  def mock_google_oauth2_auth
    mock_omniauth(
      'google_oauth2',
      uid: '123456',
      email: 'test@example.com',
      name: 'Test User'
    )
  end
end