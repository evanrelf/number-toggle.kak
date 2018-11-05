declare-option -docstring 'Line number highlighter parameters' str-list number_toggle_params

define-command -params 0.. -hidden _number_toggle_update %{
  remove-highlighter window/_number-toggle
  add-highlighter window/_number-toggle number-lines %arg{@} %opt{number_toggle_params}
}

define-command -params 0 -hidden _number_toggle_hook_focus %{
  remove-hooks window _number-toggle
  hook -group _number-toggle window FocusOut .* %{ _number_toggle_update }
  hook -group _number-toggle window FocusIn .* %{ _number_toggle_update '-relative' }
}

hook global WinCreate .* %{
  _number_toggle_update '-relative'
  _number_toggle_hook_focus
}

hook global InsertBegin .* %{
  _number_toggle_update
}

hook global InsertEnd .* %{
  _number_toggle_update '-relative'
  _number_toggle_hook_focus
}
