# app/controllers/api/v1/sessions_controller.rb
module Api
  module V1
    class SessionsController < Devise::SessionsController
      respond_to :json

      private

      def respond_with(resource, _opts = {})
        render json: {
          status: { code: 200, message: 'Logged in successfully.' },
          data: {
            id: resource.id,
            email: resource.email,
            token: request.env['warden-jwt_auth.token']
          }
        }
      end

      def respond_to_on_destroy
        if current_user
          render json: {
            status: 200,
            message: "Logged out successfully"
          }
        else
          render json: {
            status: 401,
            message: "Couldn't find an active session."
          }
        end
      end
    end
  end
end
