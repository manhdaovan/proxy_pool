require 'erb'

module ProxyPool::Balancer
  class Base
    CONFIG_PATH          = '/var/lib/%s/%s'.freeze
    CONFIG_TEMPLATE_PATH = "#{File.expand_path(File.dirname(__FILE__) + '../../conf_templates/')}/%s".freeze

    attr_reader :port, :proxy_sources, :proxies_pool

    def initialize(**options)
      @port                    = options[:port] || 8080
      @selected_proxy_sources  = options[:proxy_sources] || ['all']
      @proxy_sources           = []
      @proxies_pool            = []
      @conf_file_name          = ''
      @conf_template_file_name = ''
      build_proxy_sources
    end

    def start(*_options)
      raise StandardError, "'start' method has not implemented in #{self.class.name}"
    end

    def stop(*_options)
      raise StandardError, "'stop' method has not implemented in #{self.class.name}"
    end

    def restart
      raise StandardError, "'restart' method has not implemented in #{self.class.name}"
    end

    def add_proxy_sources(proxy_source)
      @proxy_sources << proxy_source
    end

    def add_proxy_instance(proxy)
      @proxies_pool << proxy
    end

    # Check proxy in pool by checking proxy's info
    # Eg: host and port with http, and socket path with unix
    def proxy_existed?(proxy)
      @proxies_pool.map(&:info).include?(proxy.info)
    end

    def proxy_source_existed?(proxy_src)
      @proxy_sources.map(&:src).include?(proxy_src.src)
    end

    def overwrite_conf_file
      ensure_paths
      build_proxies_pool
      check_conf_files
      build_conf_file
      copy_conf_file
    end

    def working?
      Excon.get(TEST_URL, proxy: "http://127.0.0.1:#{@port}", read_timeout: 10).status == ProxyPool::HTTP_SUCCESS_CODE
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

    protected

    def build_conf_file
      raise StandardError, "'build_conf_file' method has not implemented in #{self.class.name}"
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

    private
    def check_conf_files
      return unless @conf_file_name.empty? || @conf_template_file_name.empty?
      raise StandardError, "Please set configuration file names in #{self.class.name}"
    end

    def select_all_sources?
      @selected_proxy_sources.include?('all')
    end

    def ensure_paths
      %w(lib run log).each do |dir|
        path = "/var/#{dir}/#{balancer_name}"
        Dir.mkdir(path) unless Dir.exist?(path)
      end
    end

    def copy_conf_file
      execute('cp', config_tmp_path, config_path)
    end

    def build_proxies_pool
      @proxy_sources.each do |p_src|
        p_src.fetch_proxy
        @proxies_pool += p_src.proxies
      end
    end

    def build_proxy_sources
      if select_all_sources?
        ProxyPool::ProxySources::Base.descendants.each do |src|
          @proxy_sources << src.new
        end
      else
        @selected_proxy_sources.each do |src|
          @proxy_sources << ProxyPool.const_get("ProxyPool::ProxySources::#{src}").new
        end
      end
    end
  end
end
