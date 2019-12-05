declare-option -docstring 'Line number highlighter parameters' str-list number_toggle_params

# Update line number highlighters
define-command -params 0.. -hidden number-toggle-update %{
  # Remove existing highlighter
  remove-highlighter window/number-toggle
  # Install new highlighter
  add-highlighter window/number-toggle number-lines %arg{@} %opt{number_toggle_params}
}

# Install hooks that change line numbering in reaction to changes in focus
define-command -params 0 -hidden number-toggle-hook-focus %{
  # Remove existing hooks
  remove-hooks window number-toggle
  # Install new hooks
  hook -group number-toggle window FocusOut .* %{ number-toggle-update }
  hook -group number-toggle window FocusIn .* %{ number-toggle-update '-relative' }
}

# Display relative line numbers when starting Kakoune in normal mode
hook global WinCreate .* %{
  number-toggle-update '-relative'
  number-toggle-hook-focus
}

# Display absolute line numbers when entering insert mode
hook global ModeChange push:.*:insert %{
  number-toggle-update
}

# Display relative line numbers when leaving insert mode
hook global ModeChange pop:insert:.* %{
  number-toggle-update '-relative'
  number-toggle-hook-focus
}
