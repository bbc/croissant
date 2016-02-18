require "./connection"

module Crosaint
  module Helpers
    def connection
      @connection ||= Connection.new(
        config[:cert_location],
        config[:key_location],
        config[:composition_host],
        config[:timeout]
      )
    end

    def cosmos_env
      BBC::Cosmos::Config.cosmos.environment.downcase.tap do |env|
        return "live" if env == "docker"
      end
    end
  end
end
