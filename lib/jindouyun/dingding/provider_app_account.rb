require 'jindouyun/dingding/provider_app_account/api'

module Jindouyun::Dingding
  module ProviderAppAccount

    # Required fields:
    #   reader only:
    #     * suite_key
    #     * suite_secret
    #     * encoding_aes_key
    #     * sign_token
    #   reader and writer:
    #     * suite_ticket
    #     * suite_access_token
    #     * suite_access_token_expired_at

    BASE_URL = 'https://oapi.dingtalk.com'

    def self.included(host_class)
      host_class.include Jindouyun::HttpClient
      host_class.base_url BASE_URL
      host_class.extend Jindouyun::Dingding::ProviderAppAccount::API
      host_class.extend ClassMethods
    end

    module ClassMethods

      def refreshed_access_token
        return suite_access_token unless access_token_expired?
        refreshed_access_token!
      end

      private

      def access_token_expired?
        !(suite_access_token_expired_at && suite_access_token_expired_at >= Time.now)
      end

      def refreshed_access_token!
        result = get_suite_access_token
        token = result[:suite_access_token]
        self.suite_access_token = token
        self.suite_access_token_expired_at = Time.now + result[:expires_in].seconds
        token
      end

    end
  end
end
