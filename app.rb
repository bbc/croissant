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
      @dynamo_db = AWS::DynamoDB::Client.new :api_version => "2012-08-10"
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

    get "/client" do
      erb :client
    end

    get "/questions" do
      data = @dynamo_db.scan :table_name => "hack_day"
      data[:member].to_json
    end

    get "/questions/:id" do
      data = @dynamo_db.get_item({ :table_name => "hack_day", :key => { "QuestionID" => { :s => params[:id] } } })
      data[:item].to_json
    end

    post "/" do
      content_type :json
      resp = ::JSON.parse request.body.read

      data = @dynamo_db.get_item({ :table_name => "hack_day", :key => { "QuestionID" => { :s => resp["QuestionID"] } } })
      count = data[:item][resp["answer"]][:s].to_i
      result = count + 1

      @dynamo_db.update_item(
        :table_name        => "hack_day",
        :key               => {
          "QuestionID" => { :s => resp["QuestionID"] }
        },
        :attribute_updates => {
          resp["answer"] => {
            :value  => {
              :s => result.to_s
            },
            :action => "PUT"
          }
        }

      )
      { :repsonse => "added answer", :voted => resp["vote"]}.to_json
    end

    post "/questions" do
      content_type :json
      resp = ::JSON.parse request.body.read
      message = { "QuestionID" => SecureRandom.uuid }.merge(resp)
      settings.faye_client.publish("/clients", message.to_s)
      store_question(message)
      { :response => "added question" }.to_json
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
      @dynamo_db.put_item(:table_name => "hack_day", :item => {
        "QuestionID" => { "s" => message['QuestionID']},
        "endTime" => { "s" =>  message['endTime']},
        "questionText" => { "s" =>  message['questionText']},
        "startTime" => { "s" =>  message['startTime']}
        })
    end
  end
end
