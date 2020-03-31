declare-option -docstring 'Line number highlighter parameters' str-list number_toggle_params

declare-option -hidden -docstring 'number-toggle.kak plug internal state' str _number_toggle_internal '-relative'

define-command -hidden -docstring "_number-toggle-refresh: Update line number highlighters" \
_number-toggle-refresh -params 0 %{ evaluate-commands %sh{
  printf '%s' "add-highlighter -override window/number-toggle number-lines $kak_opt_number_toggle_params $kak_opt__number_toggle_internal"
}}

define-command -hidden -docstring "_number-toggle-install-focus-hooks: Install hooks to use absolute line numbering when window is out of focus" \
_number-toggle-install-focus-hooks -params 0 %{
  hook -group number-toggle-focus window FocusOut .* %{
    set-option window _number_toggle_internal ''
    _number-toggle-refresh
  }
  hook -group number-toggle-focus window FocusIn .* %{
    set-option window _number_toggle_internal '-relative'
    _number-toggle-refresh
  }
}

define-command -hidden -docstring "_number-toggle-uninstall-focus-hooks: Uninstall hooks to use absolute line numbering when window is out of focus" \
_number-toggle-uninstall-focus-hooks -params 0 %{
  remove-hooks window number-toggle-focus
}

# Display relative line numbers when starting Kakoune in normal mode
hook global WinCreate .* %{
  set-option window _number_toggle_internal '-relative'
  _number-toggle-refresh
  _number-toggle-install-focus-hooks
}

# Display absolute line numbers when entering insert mode
hook global ModeChange push:.*:insert %{
  set-option window _number_toggle_internal ''
  _number-toggle-refresh
  _number-toggle-uninstall-focus-hooks
}

# Display relative line numbers when leaving insert mode
hook global ModeChange pop:insert:.* %{
  set-option window _number_toggle_internal '-relative'
  _number-toggle-refresh
  _number-toggle-install-focus-hooks
}
