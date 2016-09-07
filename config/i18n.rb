I18n.available_locales = [:en, :it, :ja]

if Rails.env.development? || Rails.env.test?
  I18n.exception_handler = lambda do |exception, locale, key, options|
    raise "missing translation: #{key}"
  end
end
