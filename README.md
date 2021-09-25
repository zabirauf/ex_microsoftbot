[![MIT licensed](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/zabirauf/ex_microsoftbot/master/LICENSE.md) [![hex.pm version](https://img.shields.io/hexpm/v/httpotion.svg?style=flat)](https://hex.pm/packages/ex_microsoftbot) [![Build Status](https://travis-ci.org/zabirauf/ex_microsoftbot.svg?branch=master)](https://travis-ci.org/zabirauf/ex_microsoftbot) [![Inline docs](http://inch-ci.org/github/zabirauf/ex_microsoftbot.svg)](http://inch-ci.org/github/zabirauf/ex_microsoftbot) <a href="http://github.com/syl20bnr/spacemacs"><img src="https://cdn.rawgit.com/syl20bnr/spacemacs/442d025779da2f62fc86c2082703697714db6514/assets/spacemacs-badge.svg" alt="Made with Spacemacs"></a>

Elixir Microsoft Bot Framework Client
=====================================

This library provides Elixir API wrapper for the Microsoft Bot Framework and handles authentication and token management.

## Documentation

API documentation is available at [https://hexdocs.pm/ex_microsofbot](https://hexdocs.pm/ex_microsoftbot).

## Installation

1. Add `ex_microsoftbot` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:ex_microsoftbot, "~> 3.0.0"}]
end
```

2. Add the registered bot app id and app password in your config:

```elixir
config :ex_microsoftbot,
  app_id: "BOT_APP_ID",
  app_password: "BOT_APP_PASSWORD"
```

3. Start the `ex_microsoftbot`:

```elixir
def application do
  [applications: [:ex_microsoftbot]]
end
```

## Usage

The main functionality is provided by three main modules that match each of the corresponding API endpoints of the Microsoft Bot Framework:

* `ExMicrosoftBot.Client.Attachments`,
* `ExMicrosoftBot.Client.Conversations`
* `ExMicrosoftBot.Client.Teams`

Example usage:

```elixir
alias ExMicrosoftBot.Client.Conversations

def reply(activity = %Activity{}) do
  text = "Hello, world!"

  resp_activity =
    %Activity{
      type: "message",
      conversation: activity.conversation,
      recipient: activity.from,
      from: activity.recipient,
      replyToId: activity.id,
      text: text
    }

  Conversations.reply_to_activity(
    activity.serviceUrl,
    activity.conversation.id,
    activity.id,
    resp_activity
  )
end
```

## Config

In addition to the required auth configs mentioned in [Installation](#installation), there are a few more options available to customize this lib:

```elixir
config :ex_microsoftbot,
  using_bot_emulator: false,
  scope: "https://api.botframework.com/.default",
  http_client_opts: nil
```

#### `using_bot_emulator`

Default `false`. Set this to `true` to disable the auth token manager, and instead use a fake auth token in all requests.

#### `scope`

Default `"https://api.botframework.com/.default"`. This sets the scope used when authorizing with the BotFramework.

#### `http_client_opts`

This is passed on each request to the underlying HTTP client, [HTTPoison](https://github.com/edgurgel/httpoison). See the `:options` key [in their docs here](https://hexdocs.pm/httpoison/HTTPoison.Request.html) for all available options.

##### Connection Pools

This is currently undocumented in the link above, but HTTPoison allows [specifying a connection pool](https://github.com/edgurgel/httpoison#connection-pools) and other `:hackney` options via the `:hackney` atom in the HTTP options. For example, to configure this library to use the `:bot_framework` dedicated pool:

```elixir
config :ex_microsoft_bot,
  http_client_opts: [
    hackney: [pool: :bot_framework]
  ]
```
