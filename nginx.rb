module ProxyPool
  class Balancer
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

  class Nginx < Balancer
    def start(extra_opts = [])
      super
      base_opts = []
      system("sudo service nginx start #{(extra_opts | base_opts).join(' ')}")
    end

    def working?
      system('ps aux | grep nginx')
    end

    def spawn
      system
    end

    def build_conf_file
      super
    end
  end
end
