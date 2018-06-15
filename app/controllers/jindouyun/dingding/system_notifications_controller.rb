module Jindouyun::Dingding
  class SystemNotificationsController < ::Jindouyun::Dingding::EncryptedMessageController

    def create
      Jindouyun.logger.info "Dingding Message: #{@message_content}"

      @response_message = 'success'

      case @message_content['EventType']
      when 'check_create_suite_url'
      when 'check_update_suite_url'
        Jindouyun.logger.info "Dingding check update suite url: #{@message_content['Random']}"
        process_check_update_suite_url
      when 'suite_ticket'
        process_suite_ticket
      when 'check_suite_license_code'
        process_check_suite_license_code
      when 'tmp_auth_code'
        process_tmp_auth_code
      when 'suite_relieve'
        process_suite_relieve
      end

      render json: message_encryptor.encrypt_to_json(@response_message)
    end

    private

    def process_check_update_suite_url
      @response_message = @message_content['Random']
    end

    def process_suite_ticket
    end

    def process_check_suite_license_code
    end

    def process_tmp_auth_code
    end

    def process_suite_relieve
    end

  end
end
