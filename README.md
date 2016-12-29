[![MIT licensed](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/zabirauf/ex_microsoftbot/master/LICENSE.md) [![hex.pm version](https://img.shields.io/hexpm/v/httpotion.svg?style=flat)](https://hex.pm/packages/ex_microsoftbot) [![Build Status](https://travis-ci.org/zabirauf/ex_microsoftbot.svg?branch=master)](https://travis-ci.org/zabirauf/ex_microsoftbot) [![Inline docs](http://inch-ci.org/github/zabirauf/ex_microsoftbot.svg)](http://inch-ci.org/github/zabirauf/ex_microsoftbot) <a href="http://github.com/syl20bnr/spacemacs"><img src="https://cdn.rawgit.com/syl20bnr/spacemacs/442d025779da2f62fc86c2082703697714db6514/assets/spacemacs-badge.svg" alt="Made with Spacemacs"></a>

Elixir Microsoft Bot Client 
======================================

This library provides Elixir API wrapper for the Microsoft Bot Framework and handles authentication and token management.

## Documentation

API documentation is available at [https://hexdocs.pm/ex_microsofbot](https://hexdocs.pm/ex_microsoftbot)

## Installation

  1. Add `ex_microsoftbot` to your list of dependencies in `mix.exs`:

        def deps do
          [{:ex_microsoftbot, "~> 1.0.0"}]
        end
        
  2. Add the registered bot app id and app password in your config:
  
        config :ex_microsoftbot,
          app_id: "BOT_APP_ID",
          app_password: "BOT_APP_PASSWORD",
        
  3. Start the `ex_microsoftbot`:
  
        def application do
          [applications: [:ex_microsoftbot]]
        end
        
## Usage

The modules `ExMicrosoftBot.Client.Attachments, ExMicrosoftBot.Client.Conversations, ExMicrosoftBot.Client.BotState` contains the functions to call the corresponding API of Microsoft Bot Framework. For example

```
bot_data = ExMicrosoftBot.Client.BotState.get_user_data(channel_id, user_id)

%ExMicrosoftBot.Models.BotData{data: %{}, eTag: "string"}
```
