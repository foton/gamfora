# Where the I18n library should search for translation files
#not needed    I18n.load_path += Dir[Rails.root.join('lib', 'locale', '*.{rb,yml}')]

I18n.available_locales = [:en, :cs]
I18n.default_locale = :cs


if Rails.env.development? || Rails.env.test?
  I18n.exception_handler = lambda do |exception, locale, key, options|
    raise "missing translation[#{locale}]: #{key} (#{options})"
  end
end
