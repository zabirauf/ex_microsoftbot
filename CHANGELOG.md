# Changelog for V2.0.0

* `:jose` added to application start
* Several Activity Model additions - `inputHint`, `code`, `speak`
* Update Elixir versions to 1.5 and up
* Restructure state handling to be more robust
  * If the token gen_server is running in a supervisor process and bot framework is down, won't crash the entire application.
* Remove BotState Client and BotData models because they are [no longer supported by Microsoft](https://blog.botframework.com/2017/12/19/bot-state-service-will-soon-retired-march-31st-2018/).

# Changelog for V1.0.0

* Initial release
