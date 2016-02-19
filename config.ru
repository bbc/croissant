require_relative "env"

require "bbc/cosmos/config"
require "./app"
require "faye"
require "bundler"
require "aws-sdk"

config = { :env => ENV["RACK_ENV"] }

AWS.config(:region => "eu-west-1")

Faye::WebSocket.load_adapter "thin"
use Faye::RackAdapter, :mount => "/faye", :timeout => 45, :extensions => []
use Rack::CommonLogger, Alephant::Logger.get_logger

run Crosaint::App.new(config)
