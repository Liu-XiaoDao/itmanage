set :application, 'it_asset_jing'

# server '10.8.1.36', roles: [:app, :web, :db], primary: true

set :branch, 'staging_jing'

set :deploy_to, "/usr/rubyWeb/#{fetch(:application)}"
set :rails_env, 'staging_jing'
server "116.196.118.148", user: "blog", roles: %w{app db web}, my_property: :my_value


set :use_sudo, true
set :ssh_options, {
    forward_agent: true,
    #auth_methods: %w(password),
    # password: 'clliu',
    user: 'myuser',
}
