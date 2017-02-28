module ProxyPool::Proxy
  class Base
    attr_reader :host, :port
    attr_accessor :src
    def initialize
      @src = nil
      @host = nil
      @port = nil
    end

    def fetch_proxy; end
  end
end
