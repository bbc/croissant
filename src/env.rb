$LOAD_PATH << File.join(File.dirname(__FILE__), "lib")

ENV["APP_ENV"]      = ENV.fetch("RACK_ENV", "development")
ENV["PROJECT_PATH"] = File.dirname(__FILE__)

require "mozart/logger"
require "dotenv"
require "pry" if ENV["APP_ENV"] == "development"

Dotenv.load(
  File.join(
    File.dirname(__FILE__),
    "config",
    ENV["APP_ENV"],
    "env.yaml"
  )
)

opts = {}

if %w(production).include? ENV["RACK_ENV"]
  opts = {
    :statsd => {
      :host      => ENV["STATSD_HOST"],
      :port      => 8125,
      :namespace => "croissant"
    }
  }
end

Mozart::Logger.setup opts, ENV["APP_LOG_LOCATION"]
