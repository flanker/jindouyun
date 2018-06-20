module Jindouyun::Dingding::Account
  module API

    # Dingding response
    # {
    #   "errmsg": "ok",
    #   "ticket": "lVfNJcn8iwgasfadsfasdfadfaljsdfjalsdfBXRLFhHP335cbvqBV3dVyxE6AWfsQFCftwimXM",
    #   "expires_in": 7200,
    #   "errcode": 0
    # }
    def fetch_jsapi_ticket
      path = '/get_jsapi_ticket'
      response = fire_request path, {access_token: refreshed_access_token, type: :jsapi}, method: :get
      return response[:ticket], response
    end

    # Dingding response
    # {
    #   "userid": "manager1234",
    #   "sys_level": 1,
    #   "errmsg": "ok",
    #   "is_sys": true,
    #   "deviceId": "de3cfbcabasdfasdfef21c2c08c2d049",
    #   "errcode": 0
    # }
    def get_user_info code
      path = '/user/getuserinfo'
      fire_request path, {access_token: refreshed_access_token, code: code}, method: :get
    end

    # Dingding response
    # {
    #   "orderInDepts": "{1:98944838724408752}",
    #   "department": [1],
    #   "unionid": "JAR3LOWCasdfasdf39uwuQiEiE",
    #   "userid": "manager1234",
    #   "isSenior": false,
    #   "dingId": "$:LWCP_v1:$6SUdasdfaswre4cb5JdOTkQ==",
    #   "isBoss": false,
    #   "name": "Mary",
    #   "errmsg": "ok",
    #   "avatar": "https://static.dingtalk.com/media/lADOgfasdfM0CgM0CgA_640_640.jpg",
    #   "errcode": 0,
    #   "isLeaderInDepts": "{1:false}",
    #   "active": true,
    #   "isAdmin": true,
    #   "isHide": false
    # }
    def get_user userid
      path = '/user/get'
      fire_request path, {access_token: refreshed_access_token, userid: userid}, method: :get
    end

  end
end
