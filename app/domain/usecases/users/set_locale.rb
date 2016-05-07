module Villeme
  module UseCases
    class SetLocale

      def initialize(entity = nil)
        @user = entity
      end

      def set_locale(options = {locale: nil, test: false})
        @options = options
        set_user_locale
      end

      def set_locale_from_ip(requested_ip, options = {test: false})
        @options = options
        @user_ip = requested_ip
        set_i18n_locale_from_user_ip(@user_ip)
      end

      private

      def set_user_locale
        if params_locale?
          set_i18n_locale_equal_parameter_locale
        elsif user_locale?
          set_i18n_locale_equal_user_locale
        elsif user_ip?
          set_i18n_locale_from_user_ip(@user.ip)
        else
          set_i18n_locale_equal_default_locale
        end
      end

      def set_i18n_locale_equal_user_locale
        I18n.locale = @user.locale
        true
      end

      def set_i18n_locale_equal_parameter_locale
        I18n.locale = @options[:locale]
        true
      end

      def set_i18n_locale_from_user_ip(ip)
        country_code = geocoding(ip)
        if country_code
          set_i18n_locale_if_exist_traductions(country_code)
          true
        else
          I18n.locale = 'pt-BR'
          false
        end
      end

      def geocoding(ip)
        if @options[:test]
          'br'
        else
          Geocoder.search(ip).try(:first).try(:country_code).try(:downcase)
        end
      end

      def set_i18n_locale_if_exist_traductions(country_code)
        if /\ben|br\b/.match(country_code)
          I18n.locale = converter_to_locale(country_code)
        else
          I18n.locale = 'pt-BR'
        end
      end

      def converter_to_locale(country_code)
        case country_code
        when 'br' then 'pt-BR'
        else 'en'
        end
      end

      def set_i18n_locale_equal_default_locale
        I18n.locale = I18n.default_locale
        false
      end

      def params_locale?
        if @options && @options[:locale]
          true
        else
          false
        end
      end

      def user_ip?
        if @user && @user.ip
          true
        else
          false
        end
      end

      def user_locale?
        if @user && @user.locale
          true
        else
          false
        end
      end

    end
  end
end

