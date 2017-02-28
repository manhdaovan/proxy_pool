module ProxyPool::Proxy
  class Base
    attr_reader :host, :port
    attr_accessor :src
    def initialize(**options)
      @src = nil
      @host = nil
      @port = nil
      @type = options[:type] || 'http'
      @options = options.delete(:type)
    end

    def fetch_proxy; end

    def info
      case @type
      when 'http'
        "server #{host}:#{port} #{options_2str};"
      when 'unix'
        "unix:#{host} #{options_2str};"
      else
        "server #{host}:#{port} #{options_2str};"
      end
    end

    def options_2str
      @options.map { |k, v| "#{k}=#{v}" }.join(' ')
    end
  end
end
