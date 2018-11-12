OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, "738380834240-qjqf2tpergsbi86203i25519pjtr1oo3.apps.googleusercontent.com", "cZiTVsj8juWaGCL1_jO--zMQ",
  scope: 'email,profile', prompt: 'select_account',image_aspect_ratio: 'square', image_size: 48, access_type: 'online', name: 'google'
end

OmniAuth.config.on_failure = Proc.new do |env|
  SessionsController.action(:auth_failure).call(env)
end

OmniAuth.config.full_host = Rails.env.development? ?  'http://localhost:3000' : 'http://www.schoolay.com'