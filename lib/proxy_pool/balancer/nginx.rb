module ProxyPool::Balancer
  class Nginx < ProxyPool::Balancer::Base
    def initialize(port = 8080)
      super
      @conf_file_name          = 'nginx.conf'
      @conf_template_file_name = 'nginx.conf.erb'
    end

    def start(*extra_opts)
      overwrite_conf_file
      base_opts = [which, "-c #{config_path}"]
      execute(*(base_opts | extra_opts))
    end

    def stop(*extra_opts)
      base_opts = ['-s stop']
      execute(which, *(extra_opts | base_opts).join(' '))
    end

    def which
      path = `which nginx`.strip
      if path.empty?
        nil
      else
        path
      end
    end

    def build_conf_file
      super
      File.open(config_tmp_path, 'w+') do |config_tmp_file|
        config_tmp_file.write(ERB.new(File.read(config_template_path)).result(binding))
      end
    end
  end
end
