require 'erb'

module ProxyPool::Balancer
  class Base
    CONFIG_PATH          = '/var/lib/%s/%s'.freeze
    CONFIG_TEMPLATE_PATH = "#{File.expand_path(File.dirname(__FILE__) + '../../conf_templates/')}/%s".freeze
    TEST_URL             = 'https://ipinfo.io/ip'.freeze

    attr_reader :port
    attr_reader :proxies_pool

    def initialize(port = 8080)
      @port                    = port
      @proxies_pool            = []
      @conf_file_name          = ''
      @conf_template_file_name = ''
    end

    def start(*options)
      raise StandardError, "'start' method has not implement in #{self.class.name}"
    end

    def stop(*options)
      raise StandardError, "'stop' method has not implement in #{self.class.name}"
    end

    def restart
      raise StandardError, "'restart' method has not implement in #{self.class.name}"
    end

    def add_proxy(proxy)
      @proxies_pool << proxy
    end

    # Check proxy in pool by checking proxy's info
    # Eg: host and port with http, and socket path with unix
    def existed?(proxy)
      @proxies_pool.map { |p| p.info }.include?(proxy.info)
    end

    def overwrite_conf_file
      ensure_paths
      build_conf_file
      copy_conf_file
    end

    def build_conf_file
      ensure_paths
    end

    def config_path
      format(CONFIG_PATH, balancer_name, @conf_file_name)
    end

    def config_tmp_path
      format(CONFIG_PATH, balancer_name, "#{@conf_file_name}.tmp")
    end

    def config_template_path
      format(CONFIG_TEMPLATE_PATH, @conf_template_file_name)
    end

    def balancer_name
      self.class.name.split('::')[-1].downcase
    end

    def working?
      Excon.get(TEST_URL, proxy: "http://127.0.0.1:#{@port}", read_timeout: 10).status == 200
    rescue
      false
    end

    def ensure_running
      restart unless working?
    end

    def execute(*args)
      $logger.info("Executed: #{args.join(' ')}")
      system(args.join(' '))
    end

    private

    def ensure_paths
      %w(lib run log).each do |dir|
        path = "/var/#{dir}/#{balancer_name}"
        Dir.mkdir(path) unless Dir.exist?(path)
      end
    end

    def copy_conf_file
      execute('cp', config_tmp_path, config_path)
    end
  end
end
