module ProxyPool::Balancer
  class Nginx < ProxyPool::Balancer::Base
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
