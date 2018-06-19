require 'rest_client'

module Jindouyun
  module HttpClient

    def self.included(host_class)
      host_class.extend ClassMethods
    end

    module ClassMethods

      # e.g. 'https://oapi.dingtalk.com'
      def base_url url
        @api_base_url = url
      end

      def api_base_url
        @api_base_url
      end

      def log message
        Jindouyun.logger.info message
      end

      def fire_request path, params, base_url: nil, method: :post
        base_url = api_base_url unless base_url
        url = "#{base_url}#{path}"

        log "Jindouyun sending request to: #{url}"
        log "    with params: #{params}"

        if method == :post
          response = JSON.parse RestClient.post(
            url,
            params.to_json,
            timeout: 60,
            content_type: :json,
            accept: :json
          )
        else
          response = JSON.parse RestClient.get(
            "#{url}?#{params.to_param}",
            timeout: 60,
            content_type: :json,
            accept: :json
          )
        end

        log "Jindouyun response: #{response}"

        response&.with_indifferent_access
      end
    end

    def fire_request path, params, method: :post
      self.class.fire_request path, params, base_url: self.class.api_base_url, method: method
    end

  end
end
