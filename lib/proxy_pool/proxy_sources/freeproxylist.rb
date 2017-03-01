module ProxyPool::ProxySources
  class Freeproxylist < ProxyPool::ProxySources::Base
    def initialize(** options)
      super
      @src = 'http://free-proxy-list.net/'
    end

    # Proxy form on source page
    DOC_FORM_INDEX = {ip: 0, port: 1, code: 2, country: 3, anonymity: 4, google: 5, https: 6, last_check: 7}.freeze

    def fetch_proxy
      conn = Excon.get(@src)
      $logger.info("Fetch proxy from #{@src} with status: #{conn.status}")
      return if conn.status != ProxyPool::HTTP_SUCCESS_CODE

      page = Nokogiri::HTML(conn.body)

      page.css('#proxylisttable tbody tr').each_with_index do |tr, index|
        break if index > @max_proxy
        raw_proxy          = tr.css('td').map(&:content)
        proxy_init_options = {
          host: raw_proxy[DOC_FORM_INDEX[:ip]],
          port: raw_proxy[DOC_FORM_INDEX[:port]]
        }
        @proxies << ProxyPool::ProxySources::Proxy.new(proxy_init_options)
      end
    end
  end
end
