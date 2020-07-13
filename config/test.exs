use Mix.Config

config :ex_microsoftbot,
  app_id: "BOT_APP_ID",
  app_password: "BOT_APP_PASSWORD",
  endpoint: "http://localhost:9000",
  openid_valid_keys_url:
    "https://login.microsoftonline.com/botframework.com/v2.0/.well-known/openid-configuration",
  issuer_claim: "https://sts.windows.net/d6d49420-f39b-4df7-a1dc-d59a935871db/",
  audience_claim: "BOT_APP_ID",
  using_bot_emulator: true,
  disable_token_validation: true

config :ex_microsoftbot, Bypass, port: 5000
