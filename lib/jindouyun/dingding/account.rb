require 'jindouyun/dingding/account/api'

module Jindouyun::Dingding
  module Account

    # Required fields:
    #   field :corpid, type: String
    #   field :access_token, type: String
    #   field :expired_at, type: Time
    #   field :permanent_code, type: String
    #   def refreshed_access_token

    include Account::API

    BASE_URL = 'https://oapi.dingtalk.com'

    def self.included(host_class)
      host_class.include Jindouyun::HttpClient
      host_class.base_url BASE_URL
    end

    def refreshed_access_token
      return access_token if expired_at && expired_at >= Time.now
      refresh_access_token!
    end

    def refreshed_jsapi_ticket
      return jsapi_ticket if jsapi_ticket_expired_at && jsapi_ticket_expired_at > Time.now
      refresh_jsapi_ticket!
    end

    def jsapi_params url
      jsapi_ticket = refreshed_jsapi_ticket
      timestamp = Time.now.to_i
      noncestr = SecureRandom.urlsafe_base64(12)
      signature = sign_params timestamp: timestamp, noncestr: noncestr, jsapi_ticket: jsapi_ticket, url: URI.decode(url)
      {
        noncestr: noncestr,
        agentid: agentid,
        timestamp: timestamp,
        corpid: corpid,
        signature: signature
      }
    end

    private

    def refresh_access_token!
      response = ::Dingding::SystemAccount.get_corp_access_token(corpid, permanent_code)
      self.set access_token: response[:access_token], expired_at: expired_at_from_response(response)
      access_token
    end

    def refresh_jsapi_ticket!
      ticket, response = fetch_jsapi_ticket
      return if ticket.blank?

      self.set jsapi_ticket: ticket, jsapi_ticket_expired_at: expired_at_from_response(response)
      ticket
    end

    def expired_at_from_response response
      response[:expires_in] ? 3.minutes.ago + response[:expires_in].seconds : Time.current
    end

    def sign_params options
      to_be_singed_string = options.sort.map { |key, value| "#{key}=#{value}" }.join('&')
      Digest::SHA1.hexdigest to_be_singed_string
    end

  end
end
