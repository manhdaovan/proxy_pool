module ProxyPool::ProxySources
  class Base
    attr_reader :proxies, :src

    def initialize(** options)
      @src       = options[:src]
      @proxies   = []
      @max_proxy = options[:max_proxy] || 20
      check_options
    end

    def fetch_proxy
      raise StandardError, "'fetch_proxy' method has not implemented in #{self.class.name}"
    end

    def check_options
      return unless @src.nil?
      raise StandardError, "#{self.class.name} need source to fetch proxy."
    end
  end

  class Proxy
    TEST_URL           = 'https://ipinfo.io/ip'.freeze
    SCHEMA_TYPE_HTTP   = 'http'
    SCHEMA_TYPE_HTTPS  = 'https'
    SCHEMA_TYPE_SOCKET = 'unix'

    def initialize(** options)
      @host   = options[:host]
      @port   = options[:port]
      @schema = options[:schema] || SCHEMA_TYPE_HTTP

      options.delete(:host)
      options.delete(:port)
      options.delete(:schema)
      @options = options
      check_options
    end

    def info
      case @schema
      when 'http', 'https'
        "#{@host}:#{@port}"
      when 'unix'
        "unix:/#{@host}"
      end
    end

    def proxy_2nginx_format
      "server #{info} #{options_2str};"
    end

    def proxy_2haproxy_format
    end

    def options_2str
      @options.map { |k, v| "#{k}=#{v}" }.join(' ')
    end

    def check_options
      case @schema
      when SCHEMA_TYPE_HTTP, SCHEMA_TYPE_HTTPS
        raise StandardError, 'Proxy need both host and port in http(s) schema' if @host.nil? || @port.nil?
      when SCHEMA_TYPE_SOCKET
        raise StandardError, 'Proxy need socket location in unix schema' if @host.nil?
      end
    end

    def working?
      Excon.get(TEST_URL, proxy: "http://#{info}", read_timeout: 10).status == ProxyPool::HTTP_SUCCESS_CODE
    rescue
      false
    end

  end
end
