module Jindouyun::Dingding::ProviderAppAccount
  module API

    # Dingding response
    # {
    #     "errmsg": "ok",
    #     "expires_in": 7200,
    #     "suite_access_token": "ffc92d9c9649123456e16bdac7386bc",
    #     "errcode": 0
    # }
    def get_suite_access_token
      path = '/service/get_suite_token'
      response = fire_request path, {suite_key: suite_key, suite_secret: suite_secret, suite_ticket: suite_ticket}
      {suite_access_token: response[:suite_access_token], expires_in: response[:expires_in]}
    end

    # Dingding response
    # {
    #     "permanent_code": "xxxx",
    #     "ch_permanent_code": "xxxx", // 如果该套件下存在服务窗应用，会返回ch_permanent_code，代表服务窗应用永久授权码
    #     "auth_corp_info":
    #     {
    #         "corpid": "xxxx",
    #         "corp_name": "name"
    #     }
    # }
    def get_permanent_code auth_code
      path = "/service/get_permanent_code?suite_access_token=#{refreshed_access_token}"
      fire_request path, {tmp_auth_code: auth_code}
    end

    # Dingding response
    # {
    #     "errcode": 0,
    #     "errmsg": "ok"
    # }
    def activate_suite corpid, permanent_code
      path = "/service/activate_suite?suite_access_token=#{refreshed_access_token}"
      fire_request path, {suite_key: suite_key, auth_corpid: corpid, permanent_code: permanent_code}
    end

    # Dingding response
    # {
    #     "access_token": "xxxxxx",
    #     "expires_in": 7200
    # }
    def get_corp_access_token corpid, permanent_code
      path = "/service/get_corp_token?suite_access_token=#{refreshed_access_token}"
      fire_request path, {auth_corpid: corpid, permanent_code: permanent_code}
    end

    # Dingding response
    # {
    #    "auth_corp_info": {
    #       "corp_logo_url": "http://xxxx.png",
    #       "corp_name": "corpid",
    #       "corpid": "auth_corpid_value",
    #       "industry": "互联网",
    #       "invite_code": "1001",
    #       "license_code": "xxxxx",
    #       "auth_channel": "xxxxx",
    #       "auth_channel_type": "xxxxx",
    #       "is_authenticated": false,
    #       "auth_level": 0,
    #       "invite_url": "https://yfm.dingtalk.com/invite/index?code=xxxx"
    #     },
    #     "auth_user_info": {
    #         "userId": ""
    #     },
    #     "auth_info": {
    #         "agent": [{
    #             "agent_name": "aaaa",
    #             "agentid": 1,
    #             "appid": -3,
    #             "logo_url": "http://aaaaaa.com",
    #             "admin_list": ["zhangsan", "lisi"]
    #         }
    #         ,{
    #             "agent_name": "bbbb",
    #             "agentid": 4,
    #             "appid": -2,
    #             "logo_url": "http://vvvvvv.com",
    #             "admin_list": []
    #         }]
    #     },
    #     "channel_auth_info": {
    #         "channelAgent": [
    #              {
    #                  "agent_name": "应用1",
    #                  "agentid": 36,
    #                  "appid": 6,
    #                  "logo_url": "http://i01.lw.test.aliimg.com/media/lALOAFWTc8zIzMg_200_200.png"
    #              },
    #              {
    #                  "agent_name": "应用2",
    #                  "agentid": 35,
    #                  "appid": 7,
    #                  "logo_url": "http://i01.lw.test.aliimg.com/media/lALOAFWTc8zIzMg_200_200.png"
    #              }
    #         ]
    #     },
    #     "errcode": 0,
    #     "errmsg": "ok"
    # }
    def get_auth_info corpid, permanent_code
      path = "/service/get_auth_info?suite_access_token=#{refreshed_access_token}"
      fire_request path, {auth_corpid: corpid, permanent_code: permanent_code, suite_key: suite_key}
    end

  end
end
