# config valid for current version and patch releases of Capistrano
lock "~> 3.10.1"
#
# set :application, "my_app_name"
# set :repo_url, "git@example.com:me/my_repo.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure



set :stages, %w(production staging)
set :default_stage, 'staging'

set :application, "it_asset"

set :deploy_user, 'xiaodao'

set :repo_url, 'git@github.com:Liu-XiaoDao/itmanage.git'

set :branch, 'master'
# set :scm_verbose, true




set :keep_releases, 10



set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')
set :linked_dirs, fetch(:linked_dirs) + %w{public/uploads public/images}
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml', 'config/email.yml')

set :config_dirs, %W{config config/environments/#{fetch(:stage)} public/system public/uploads}
set :config_files, %w{config/database.yml config/secrets.yml  config/email.yml}


# precompile assets - locations that we will look for changed assets to determine whether to precompile
set :assets_dependencies, %w(app/assets lib/assets Gemfile config/routes.rb)


namespace :deploy do
  namespace :assets do
    desc "Precompile assets if changed"
    task :precompile do
      on roles(:app) do
        invoke 'deploy:assets:precompile_changed'
        #Rake::Task["deploy:assets:precompile_changed"].invoke
      end
    end
  end
end



#
# before "deploy", "deploy:web:disable"
# after "deploy", "deploy:web:enable"
