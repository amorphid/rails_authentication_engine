module RailsAuthenticationEngine
  module PresenterHelpers
    private

    def flash_now(type: nil, message: nil)
      if type && message
        flash.now[type] = message
      end
    end

    def render_new(alert = {})
      render_type({
        type:  :new,
        alert: alert
      })
    end

    def render_show(alert = {})
      render_type({
        type:  :show,
        alert: alert
      })
    end

    def render_type(type:, alert:)
      flash_now(alert)
      render(type, locals: { presenter: presenter })
    end
  end
end
