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

Mozart::Logger.setup opts, ENV["APP_LOG_LOCATION"]
