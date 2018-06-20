module Jindouyun::Dingding
  class UrlHelper

    class << self

      def sns_user_oauth_path(redirect_uri, appid: nil, state: '')
        "https://oapi.dingtalk.com/connect/qrconnect?appid=#{appid}&response_type=code&scope=snsapi_login&state=#{state}&redirect_uri=#{redirect_uri}"
      end

    end
  end
end
