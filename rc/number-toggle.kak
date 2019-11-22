declare-option -docstring 'Line number highlighter parameters' str-list number_toggle_params

define-command -params 0.. -hidden number_toggle_update %{
  remove-highlighter window/number-toggle
  add-highlighter window/number-toggle number-lines %arg{@} %opt{number_toggle_params}
}

define-command -params 0 -hidden number_toggle_hook_focus %{
  remove-hooks window number-toggle
  hook -group number-toggle window FocusOut .* %{ number_toggle_update }
  hook -group number-toggle window FocusIn .* %{ number_toggle_update '-relative' }
}

hook global WinCreate .* %{
  number_toggle_update '-relative'
  number_toggle_hook_focus
}

hook global ModeChange push:.*:insert %{
  number_toggle_update
}

hook global ModeChange pop:insert:.* %{
  number_toggle_update '-relative'
  number_toggle_hook_focus
}
