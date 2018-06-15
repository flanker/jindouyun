module ActionDispatch::Routing
  class Mapper

    def with_jindouyun options
      init_dingding_routes options
    end

    private

    def init_dingding_routes options
      notifications_controller = options[:system_notifications] ? options[:system_notifications] : 'jindouyun/dingding/system_notifications'

      scope :dingding do
        resources :system_notifications, controller: notifications_controller, only: [:create]
      end
    end

  end
end
