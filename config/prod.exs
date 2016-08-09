use Mix.Config

config :ex_microsoftbot,
  endpoint: "http://localhost:3978",
  openid_valid_keys_url: "https://login.microsoftonline.com/common/v2.0/.well-known/openid-configuration",
  issuer_claim: "https://api.botframework.com",
  audience_claim: Application.get_env(:ex_microsoftbot, :app_id),

config :logger,
  compile_time_purge_level: :error
