require_relative "env"

require "bbc/cosmos/config"
require "./app"
require "faye"
require "bundler"

config = { :env => ENV["RACK_ENV"] }

Faye::WebSocket.load_adapter "puma"
use Faye::RackAdapter, :mount => "/faye", :timeout => 45, :extensions => []
use Rack::CommonLogger, Alephant::Logger.get_logger

run Crosaint::App.new(config)
