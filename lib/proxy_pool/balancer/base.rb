module ProxyPool::Balancer
  class Base
    attr_reader :port
    attr_accessor :proxy_pool

    def initialize(port = 8080)
      @port       = port
      @proxy_pool = []
    end

    def start(options = []); end

    def spawn; end

    def add_proxy(proxy)
      @proxy_pool << proxy
    end

    def existed?(proxy)
      @proxy_pool.include?(proxy)
    end

    def build_conf_file; end
  end
end
