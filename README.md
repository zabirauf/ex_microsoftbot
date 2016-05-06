[![MIT licensed](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/zabirauf/ex_microsoftbot/master/LICENSE.md) [![Build Status](https://travis-ci.org/zabirauf/ex_microsoftbot.svg?branch=master)](https://travis-ci.org/zabirauf/ex_microsoftbot) [![Inline docs](http://inch-ci.org/github/zabirauf/ex_microsoftbot.svg)](http://inch-ci.org/github/zabirauf/ex_microsoftbot) <a href="http://github.com/syl20bnr/spacemacs"><img src="https://cdn.rawgit.com/syl20bnr/spacemacs/442d025779da2f62fc86c2082703697714db6514/assets/spacemacs-badge.svg" alt="Made with Spacemacs"></a>

# Elixir Microsoft Bot Client 

## Documentation

API documentation is available at TODO.

## Installation

  1. Add ex_microsoftbot to your list of dependencies in `mix.exs`:

        def deps do
          [{:ex_microsoftbot, "~> 0.1.0"}]
        end
        
## Usage

The module `ExMicrosoftBot.Client` contains the functions to call the Microsoft bot API. For example

```
auth_data = %ExMicrosoftBot.Models.AuthData{app_id: "APPID", app_secret: "APP_SECRET"}

bot_data = ExMicrosoftBot.Client.get_user_data(auth_data, bot_id, user_id)

%ExMicrosoftBot.Models.BotData{data: %{}, eTag: "string"}
```
