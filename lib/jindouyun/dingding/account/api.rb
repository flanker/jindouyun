module Jindouyun::Dingding::Account
  module API

    def fetch_jsapi_ticket
      path = '/get_jsapi_ticket'
      response = fire_request path, {access_token: refreshed_access_token, type: :jsapi}, method: :get
      return response[:ticket], response
    end

    def get_user_info code
      path = '/user/getuserinfo'
      fire_request path, {access_token: refreshed_access_token, code: code}, method: :get
    end

    def get_user userid
      path = '/user/get'
      fire_request path, {access_token: refreshed_access_token, userid: userid}, method: :get
    end

  end
end
