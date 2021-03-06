require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module CidadeVc
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :en
    config.i18n.fallbacks = true


    # Config the recognize foldersgit to javascript and css
    # config.assets.paths << Rails.root.join('vendor', 'assets', 'components')

    # Carrega arquivos no /lib
    config.autoload_paths += Dir["#{config.root}/app/models/**/*", "#{config.root}/app/domain/**/", "#{config.root}/app/services/**/", "#{config.root}/app/factories/**/", "#{config.root}/app/domain/usecases/**/","#{config.root}/lib/**/"]

    # Constantes do aplicativo
    HOME_URL = "http://www.villeme.com"

    # Error handling in transaction callbacks
    config.active_record.raise_in_transactional_callbacks = true

    config.time_zone = 'Brasilia'

    config.assets.initialize_on_precompile = false

    # Postmark
    config.action_mailer.delivery_method   = :postmark
    config.action_mailer.postmark_settings = { :api_key => ENV['POSTMARK_API_KEY'] }

    # Facebook
    FACEBOOK_APP_ID = ENV['FACEBOOK_APP_ID']



  end
end
