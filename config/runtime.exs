import Config

# config/runtime.exs is executed for all environments, including
# during releases. It is executed after compilation and before the
# system starts, so it is typically used to load production configuration
# and secrets from environment variables or elsewhere. Do not define
# any compile-time configuration in here, as it won't be applied.
# The block below contains prod specific runtime configuration.

# ## Using releases
#
# If you use `mix release`, you need to explicitly enable the server
# by passing the PHX_SERVER=true when you start it:
#
#     PHX_SERVER=true bin/lis start
#
# Alternatively, you can use `mix phx.gen.release` to generate a `bin/server`
# script that automatically sets the env var above.
if System.get_env("PHX_SERVER") do
  config :lis, LISWeb.Endpoint, server: true
end

if config_env() == :prod do
  database_path =
    System.get_env("DATABASE_PATH") ||
      raise """
      environment variable DATABASE_PATH is missing.
      For example: /etc/lis/lis.db
      """

  config :lis, LIS.Repo,
    database: database_path,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "5")

  # The secret key base is used to sign/encrypt cookies and other secrets.
  # A default value is used in config/dev.exs and config/test.exs but you
  # want to use a different value for prod and you most likely don't want
  # to check this value into version control, so we use an environment
  # variable instead.
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  host = System.get_env("PHX_HOST") || "example.com"
  port = String.to_integer(System.get_env("PORT") || "80")
  sport = String.to_integer(System.get_env("HTTPS_PORT") || "443")

  config :lis, :dns_cluster_query, System.get_env("DNS_CLUSTER_QUERY")

  config :lis, LIS.Mailer, adapter: Swoosh.Adapters.Logger, level: :info, log_full_email: true

  config :lis, LISWeb.Endpoint,
    # url: [host: host, port: port, scheme: "http"],
    http: [
      # Enable IPv6 and bind on all interfaces.
      # Set it to  {0, 0, 0, 0, 0, 0, 0, 1} for local network only access.
      # See the documentation on https://hexdocs.pm/bandit/Bandit.html#t:options/0
      # for details about using IPv6 vs IPv4 and loopback vs public addresses.
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: port
    ],
    # ## SSL Support
    #
    url: [host: host, port: sport, scheme: "https"],
    https: [
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: sport,
      # The `cipher_suite` is set to `:strong` to support only the
      # latest and more secure SSL ciphers. This means old browsers
      # and clients may not be supported. You can set it to
      # `:compatible` for wider support.
      cipher_suite: :strong,
      # `:keyfile` and `:certfile` expect an absolute path to the key
      # and cert in disk or a relative path inside priv, for example
      # "priv/ssl/server.key". For all supported SSL configuration
      # options, see https://hexdocs.pm/plug/Plug.SSL.html#configure/1
      keyfile: System.fetch_env!("LIS_SSL_KEY_PATH"),
      certfile: System.fetch_env!("LIS_SSL_CERT_PATH")
    ],
    secret_key_base: secret_key_base
end
