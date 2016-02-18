require "faraday"
require "openssl"
require "alephant/logger"
require "json"

module Crosaint
  class Connection
    include Alephant::Logger

    def initialize(cert, key, host, timeout)
      if cert.nil? || key.nil?
        @connection = http_connection(host, timeout)
      else
        @connection = ssl_connection(cert, key, host, timeout)
      end
    end

    def post(path, routing_hash)
      connection.post do |req|
        req.url path
        req.headers["Content-Type"] = "application/json"
        req.body = routing_hash.to_json
      end
    rescue Faraday::TimeoutError => e
      logger.error(
        "event"            => "CompositionTimeoutError",
        "path"             => path,
        "exceptionType"    => e.class,
        "exceptionMessage" => e.message,
        "method"           => "#{self.class.name}##{__method__}"
      )
    end

    def get_page(path)
      connection.get path
    rescue Faraday::TimeoutError => e
      logger.error(
        "event"            => "CompositionTimeoutError",
        "path"             => path,
        "exceptionType"    => e.class,
        "exceptionMessage" => e.message,
        "method"           => "#{self.class.name}##{__method__}"
      )
    end

    private

    attr_reader :connection

    def client_key(key)
      OpenSSL::PKey::RSA.new File.read(key)
    end

    def client_cert(cert)
      OpenSSL::X509::Certificate.new File.read(cert)
    end

    def http_connection(host, timeout)
      Faraday.new(host).tap do |conn|
        conn.options.timeout = timeout.to_i
      end
    end

    def ssl_connection(cert, key, host, timeout)
      Faraday.new(host, :ssl => ssl_options(cert, key)).tap do |conn|
        conn.options.timeout = timeout.to_i
      end
    end

    def ssl_options(cert, key)
      {
        :client_cert => client_cert(cert),
        :client_key  => client_key(key),
        :verify      => false,
        :version     => "TLSv1"
      }
    end
  end
end
