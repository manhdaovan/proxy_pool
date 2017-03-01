require 'logger'
require 'excon'
require 'nokogiri'

$logger = Logger.new(STDOUT, ENV['DEBUG'] ? Logger::DEBUG : Logger::INFO)

module ProxyPool
  HTTP_SUCCESS_CODE = 200
end

require 'proxy_pool/version'
require 'proxy_pool/balancer/base'
require 'proxy_pool/balancer/nginx'
require 'proxy_pool/balancer/haproxy'
require 'proxy_pool/proxy_sources/base'
require 'proxy_pool/proxy_sources/freeproxylist'
