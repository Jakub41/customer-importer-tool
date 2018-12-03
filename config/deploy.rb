# frozen_string_literal: true

require 'capistrano-db-tasks'

# config valid for current version and patch releases of Capistrano
lock '~> 3.11'

set :application, 'device_manager'
set :repo_url, 'git@bitbucket.org:frommel/did2.git'
# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/opt/app'
# set :deploy_to, "/home/ubuntu/#{fetch :application}"
set :init_system, :systemd

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, 'config/puma.rb'
append :linked_files, '.env'
# set :linked_files, %w{config/database.yml config/secrets.yml config/unicorn.rb}

# Default value for linked_dirs is []
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system', 'storage'
# set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
set :ssh_options, forward_agent: true
set :puma_conf, "#{shared_path}/config/puma.rb"
append :rvm_map_bins, 'rails'
append :rvm_map_bins, 'sidekiq'
append :rvm_map_bins, 'sidekiqctl'

# set :db_dump_dir, "./tmp"
set :assets_dir, %w[storage]
set :local_assets_dir, %w[storage]

# for capistrano-sidekiq
set :bundler_path, '/home/ubuntu/.rvm/gems/ruby-2.5.1@global/wrappers/bundle'
