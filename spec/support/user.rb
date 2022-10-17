module Support
  class User
    include ApiGuard::Test::ControllerHelper
    attr_reader :token

    def initialize(role: :musician, expired: false)
      user = FactoryBot::create(role)
      @token = jwt_and_refresh_token(user, 'user', expired)
    end

    def headers
      {
        "Authorization": "Bearer #{@token.first}",
        "Refresh-Token": @token.last
      }
    end
  end
end
