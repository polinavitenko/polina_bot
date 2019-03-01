
module Faraday
  class Adapter
    class NetHttp
      def net_http_connection(env)
        proxy = {uri: PROXY,
                #  user: login,
                #  password: password,
                 socks: true}
        if proxy
          if proxy[:socks]
            env[:ssl] = {verify: true}
            sock_proxy(proxy)
          else
            env[:ssl] = {verify: false}
            http_proxy(proxy)
          end
        else
          Net::HTTP
        end.new(env[:url].host, env[:url].port)
      end

      private

      def sock_proxy(proxy)
        proxy_uri = URI.parse(proxy[:uri])
        TCPSocket.socks_username = proxy[:user] if proxy[:user]
        TCPSocket.socks_password = proxy[:password] if proxy[:password]
        Net::HTTP::SOCKSProxy(proxy_uri.host, proxy_uri.port)
      end

      def http_proxy(proxy)
        proxy_uri = URI.parse(proxy[:uri])
        Net::HTTP::Proxy(proxy_uri.host,
                         proxy_uri.port,
                         proxy_uri.user,
                         proxy_uri.password)
      end
    end
  end
end
