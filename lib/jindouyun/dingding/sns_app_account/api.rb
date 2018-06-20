module Jindouyun::Dingding::SnsAppAccount
  module API

    # Dingding response
    # {
    #     "access_token": "070c171a26aaaaa631dxxxxxxxx",
    #     "errcode": 0,
    #     "errmsg": "ok"
    # }
    def get_sns_access_token
      path = '/sns/gettoken'
      response = fire_request path, {appid: app_id, appsecret: app_secret}, method: :get
      response[:access_token]
    end

    # Dingding response
    # {
    #     "errcode": 0,
    #     "errmsg": "ok",
    #     "openid": "liSisdffdsxxxxx",
    #     "persistent_code": "dsa-d-asdasdasdfdsfninINIn-ssdasd",
    #     "unionid": "7Huu46kk"
    # }
    def get_persistent_code tmp_auth_code
      path = "/sns/get_persistent_code?access_token=#{refreshed_access_token}"
      fire_request path, {tmp_auth_code: tmp_auth_code}
    end

    # Dingding response
    # {
    #     "errcode": 0,
    #     "errmsg": "ok",
    #     "expires_in": 7200,
    #     "sns_token": "c76dsc87dsdfsdfd87csdcxxxxx"
    # }
    def get_sns_token openid, persistent_code
      path = "/sns/get_sns_token?access_token=#{refreshed_access_token}"
      fire_request path, {openid: openid, persistent_code: persistent_code}
    end

    # Dingding response
    # {
    #     "errcode": 0,
    #     "errmsg": "ok",
    #     "user_info": {
    #         "maskedMobile": "130****1234",
    #         "nick": "张三",
    #         "openid": "liSii8KCxxxxx",
    #         "unionid": "7Huu46kk"
    #     }
    # }
    def get_user_info sns_token
      path = "/sns/getuserinfo?sns_token=#{sns_token}"
      fire_request path, {}, method: :get
    end

  end
end
