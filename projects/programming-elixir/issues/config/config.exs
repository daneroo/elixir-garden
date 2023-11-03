import Config

config :issues,
  github_url: "https://api.github.com"

config :logger,
  compile_time_purge_matching: [
    [level_lower_than: :info],
    [application: :issues, level_lower_than: :info]
  ]

# Finally, the line import_config "#{config_env()}.exs"
# will import other config files based on the current configuration environment,
# such as config/dev.exs and config/test.exs.
# import_config "#{config_env()}.exs"
