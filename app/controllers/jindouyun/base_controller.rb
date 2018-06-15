module Jindouyun
  class BaseController < ActionController::Base

    private

    def log message
      Jindouyun.logger.info message
    end

  end
end
