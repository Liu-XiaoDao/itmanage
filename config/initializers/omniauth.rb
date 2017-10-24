Rails.application.config.middleware.use OmniAuth::Strategies::LDAP,
  :title => "Abcam Authentication",
  :host => '10.8.1.20',
  :port => 389,
  :method => :plain,
  :base => 'dc=abcam, dc=com',
  :uid => 'sAMAccountName',
  :bind_dn => ENV['LDAP_ADMIN_USER'],
  :password => ENV['LDAP_ADMIN_PASSWORD']
