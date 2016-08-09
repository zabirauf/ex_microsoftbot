
use Mix.Config

config :ex_microsoftbot,
  app_id: "BOT_APP_ID",
  app_password: "BOT_APP_PASSWORD",
  endpoint: "http://localhost:9000",
  openid_valid_keys_url: "https://login.microsoftonline.com/common/v2.0/.well-known/openid-configuration",
  issuer_claim: "https://sts.windows.net/72f988bf-86f1-41af-91ab-2d7cd011db47/",
  audience_claim: "https://graph.microsoft.com",
  bot_emulator_extra_validation: true
