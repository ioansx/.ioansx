# config.nu
#
# Installed by:
# version = "0.107.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings,
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R

$env.config.show_banner = false

$env.config.history = {
  file_format: sqlite
  max_size: 5_000_000
  sync_on_enter: true
  isolation: true
}

$env.config.edit_mode = "vi"
$env.config.buffer_editor = ["nvim", "--clean"]

$env.config.table.mode = "default"
$env.config.table.padding.left = 0
$env.config.table.padding.right = 0
$env.config.table.trim.methodology = "wrapping"
$env.config.table.trim.wrapping_try_keep_words = true

$env.config.completions.algorithm = "fuzzy"

$env.config.error_style = "plain"
$env.config.display_errors.exit_code = true

$env.config.datetime_format.normal = "%y-%m-%d %H:%M:%S"

$env.PROMPT_COMMAND = {||
    let p = $" (pwd) "
    let home = ($nu.home-path)
    $" ($p | str replace $home ~) "
}
$env.PROMPT_COMMAND_RIGHT = { $"(date now | format date '%Y-%d-%m %H:%M:%S%.3f')" }
$env.PROMPT_INDICATOR_VI_INSERT = ": "
$env.PROMPT_INDICATOR_VI_NORMAL = "# "

alias ll = ls -a
alias lg = lazygit

source ~/.config/nushell/.zoxide.nu
