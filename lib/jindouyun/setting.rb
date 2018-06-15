module Jindouyun
  class Setting

    def self.setting
      @dingding_setting
    end

    # {
    #   suite_id: '',
    #   sign_token: '',
    #   encoding_aes_key: ''
    # }
    def self.setting= settings
      @dingding_setting = settings
    end

  end
end
