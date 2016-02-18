require "./helpers"
require "sinatra"
require "sinatra/base"
require "rest-client"
require "openssl"
require "json"
require "faye"

module Crosaint
  class App < Sinatra::Base
    include Alephant::Logger

    helpers Crosaint::Helpers

    def initialize(config)
      @config = config
      configure
      super()
    end

    set :public_folder, File.expand_path("../", __FILE__)
    set :port, 9292
    set :faye_client, Faye::Client.new("http://localhost:9292/faye")

    before do
      request.path_info.sub! %r{/$}, ""
    end

    get "/" do
      erb :index
    end

    get "/questions" do
    end

    get "/questions/:id" do
      "hello"
    end

    post "/questions" do
      content_type :json
      message = ::JSON.parse request.body.read
      settings.faye_client.publish("/question", message)
      {:response => "Question Sent"}.to_json
    end

    post "/" do
      content_type :json

    end

    get "/status" do
      "ok"
    end

    def configure
      self.class.tap do |s|
        s.configure { s.disable :show_exceptions, :raise_errors }
      end
    end
  end
end
