use Mix.Config

config :ex_microsoftbot,
  endpoint: "https://api.botframework.com",
  openid_valid_keys_url: "https://api.aps.skype.com/v1/.well-known/openidconfiguration",
  issuer_claim: "https://api.botframework.com",
  audience_claim: Application.get_env(:ex_microsoftbot, :app_id),
  disable_token_validation: false

config :logger,
  compile_time_purge_level: :error
