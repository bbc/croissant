require "./app"
require "faye"
require "bundler"
require "aws-sdk"

AWS.config(:region => "eu-west-1")

Faye::WebSocket.load_adapter "thin"
use Faye::RackAdapter, :mount => "/faye", :timeout => 45, :extensions => []
use Rack::CommonLogger

run Crosaint::App.new
