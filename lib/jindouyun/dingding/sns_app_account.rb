require 'jindouyun/dingding/sns_app_account/api'

module Jindouyun::Dingding
  module SnsAppAccount

    # Required fields:
    #   reader only:
    #     * app_id
    #     * app_secret
    #   reader and writer:
    #     * sns_access_token
    #     * sns_access_token_expired_at

    BASE_URL = 'https://oapi.dingtalk.com'

    def self.included(host_class)
      host_class.include Jindouyun::HttpClient
      host_class.base_url BASE_URL
      host_class.extend Jindouyun::Dingding::SnsAppAccount::API
      host_class.extend ClassMethods
    end

    module ClassMethods

      def refreshed_access_token
        return sns_access_token unless access_token_expired?
        refreshed_access_token!
      end

      private

      def access_token_expired?
        !(sns_access_token_expired_at && sns_access_token_expired_at >= Time.now)
      end

      def refreshed_access_token!
        token = get_sns_access_token
        self.sns_access_token = token
        self.sns_access_token_expired_at = Time.now + 1.hour + 50.minutes
        token
      end

    end
  end
end
