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
      dynamo_db = AWS::DynamoDB.new
      @table = dynamo_db.tables['hack_day']
      configure
      super()
    end

    set :public_folder, File.expand_path("../", __FILE__)
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

    post "/" do
      content_type :json
      resp = ::JSON.parse request.body.read
      item = @table.items[resp["QuestionID"]]
      count = item.attributes[resp["answer"]] + 1
      item.attributes.update do |u|
         u.set resp["answer"] => count
       end
       { :repsonse => "added answer" }.to_json
    end

    post "/questions" do
      content_type :json
      resp = ::JSON.parse request.body.read
      message = {'QuestionID' => SecureRandom.uuid}.merge(resp)
      settings.faye_client.publish("/clients", message.to_s)
      store_question(message)
      { :repsonse => "added quetsion" }.to_json
    end

    get "/status" do
      "ok"
    end

    def configure
      self.class.tap do |s|
        s.configure { s.disable :show_exceptions, :raise_errors }
      end
    end
    def store_question(message)
      @table.items.create(message)
    end
  end
end
