require "./helpers"
require "sinatra"
require "sinatra/base"
require "rest-client"
require "openssl"
require "json"
require "faye"
require "yaml"
require "pry"

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
    set :saved_data, Hash.new([])

    before do
      request.path_info.sub! %r{/$}, ""
    end

    get "/" do
      @saved_data = settings.saved_data
      erb :index
    end

    get "/client" do
      erb :client
    end

    get "/questions" do
    end

    get "/questions/:id" do
      "hello"
    end

    post "/" do
      channel = params["channel"]
      message = params["message"]

      settings.faye_client.publish(channel, message)
      settings.saved_data[channel] += [message]

      redirect to("/")
    end

    post "/questions" do
      content_type :json
      resp = ::JSON.parse request.body.read
      message = {'QuestionID' => SecureRandom.uuid}.merge(resp)
      settings.faye_client.publish("/clients", message.to_s)
      { :response => "added question", :voted => resp["vote"] }.to_json
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
