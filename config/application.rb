# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CustomerImporterTool
  class Application < Rails::Application
    config.load_defaults 5.2

    if ENV['HTTP_HOST']
      self.default_url_options = {
        host: ENV.fetch('HTTP_HOST'),
        protocol: ENV.fetch('HTTP_PROTOCOL')
      }
    end

    config.action_controller.default_url_options = default_url_options
    config.action_mailer.default_url_options = default_url_options
    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address: ENV['SMTP_ADDRESS'] || 'smtp.gmail.com',
      port: ENV['SMTP_PORT'] || 587,
      domain: ENV['SMTP_DOMAIN'] || 'example.com',
      user_name: ENV['SMTP_USER'],
      password: ENV['SMTP_PASSWORD'],
      authentication: 'plain',
      enable_starttls_auto: true
    }

    config.action_mailer.raise_delivery_errors = true
    config.active_job.queue_adapter = :sidekiq

    config.generators do |g|
      g.test_framework :rspec, fixture: false
      g.factory_bot false
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
      g.assets false
      g.helper false
      g.stylesheets false
      g.view_specs false
      g.helper_specs false
    end
  end
end
