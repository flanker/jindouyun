module Jindouyun::Dingding
  class EncryptedMessageController < ::Jindouyun::BaseController

    before_action :decrypt_payload_and_verify, only: [:create]
    before_action :parse_json_payload, only: [:create]

    def create
    end

    private

    def message_encryptor
      @message_encryptor ||= Jindouyun::MessageEncryptor.new encoding_aes_key: Jindouyun::Setting.setting[:encoding_aes_key],
                                                             sign_token: Jindouyun::Setting.setting[:sign_token],
                                                             app_id: Jindouyun::Setting.setting[:suite_id]
    end

    def decrypt_payload_and_verify
      @message, _app_id, calculated_sign = message_encryptor.decrypt params
      head :bad_request unless params[:signature] == calculated_sign
    end

    def service_verify?
      params[:echostr].present?
    end

    def parse_json_payload
      @message_content = JSON.parse(@message)
    end

    def encrypted_user_text_response from_user_name, to_user_name, content
      response_content = "<xml><ToUserName><![CDATA[#{to_user_name}]]></ToUserName><FromUserName><![CDATA[#{from_user_name}]]></FromUserName><CreateTime>#{Time.now.to_i}</CreateTime><MsgType><![CDATA[text]]></MsgType><Content><![CDATA[#{content}]]></Content></xml>"
      message_encryptor.encrypt_to_xml response_content
    end

  end
end
