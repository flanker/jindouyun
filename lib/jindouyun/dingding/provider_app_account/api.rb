module Jindouyun::Dingding::ProviderAppAccount
  module API

    def get_suite_access_token
      path = '/service/get_suite_token'
      response = fire_request path, {suite_key: suite_key, suite_secret: suite_secret, suite_ticket: suite_ticket}
      {suite_access_token: response[:suite_access_token], expires_in: response[:expires_in]}
    end

    def get_permanent_code auth_code
      path = "/service/get_permanent_code?suite_access_token=#{refreshed_access_token}"
      fire_request path, {tmp_auth_code: auth_code}
    end

    def activate_suite corpid, permanent_code
      path = "/service/activate_suite?suite_access_token=#{refreshed_access_token}"
      fire_request path, {suite_key: suite_key, auth_corpid: corpid, permanent_code: permanent_code}
    end

    def get_corp_access_token corpid, permanent_code
      path = "/service/get_corp_token?suite_access_token=#{refreshed_access_token}"
      fire_request path, {auth_corpid: corpid, permanent_code: permanent_code}
    end

    def get_auth_info corpid, permanent_code
      path = "/service/get_auth_info?suite_access_token=#{refreshed_access_token}"
      fire_request path, {auth_corpid: corpid, permanent_code: permanent_code, suite_key: suite_key}
    end

  end
end
