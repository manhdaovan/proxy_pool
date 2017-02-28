require 'logger'

$logger = Logger.new(STDOUT, ENV['DEBUG'] ? Logger::DEBUG : Logger::INFO)

module ProxyPool
end

require 'proxy_pool/balancer/base'
require 'proxy_pool/balancer/nginx'
require 'proxy_pool/balancer/haproxy'
require 'proxy_pool/proxy/base'
require 'proxy_pool/proxy/bitproxies'
require 'proxy_pool/proxy/freeproxylist'
require 'proxy_pool/proxy/scrapebox'
