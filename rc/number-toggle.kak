declare-option -docstring 'Line number highlighter parameters' str-list number_toggle_params

define-command -params 0.. -hidden number-toggle-update %{
  remove-highlighter window/number-toggle
  add-highlighter window/number-toggle number-lines %arg{@} %opt{number_toggle_params}
}

define-command -params 0 -hidden number-toggle-hook-focus %{
  remove-hooks window number-toggle
  hook -group number-toggle window FocusOut .* %{ number-toggle-update }
  hook -group number-toggle window FocusIn .* %{ number-toggle-update '-relative' }
}

hook global WinCreate .* %{
  number-toggle-update '-relative'
  number-toggle-hook-focus
}

hook global ModeChange push:.*:insert %{
  number-toggle-update
}

hook global ModeChange pop:insert:.* %{
  number-toggle-update '-relative'
  number-toggle-hook-focus
}
