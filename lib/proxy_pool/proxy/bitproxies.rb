module ProxyPool::Proxy
  class Bitproxies < ProxyPool::Proxy::Base
    def fetch_proxy
      super
      @host = host
      @port = port
    end
end
end
