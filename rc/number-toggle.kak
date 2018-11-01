declare-option -docstring 'Line number highlighter parameters' str-list number_toggle_params

hook global WinCreate .* %{
  evaluate-commands %sh{
    echo "add-highlighter window/number-toggle number-lines -relative $kak_opt_number_toggle_params"
  }
}

hook global ModeChange normal:insert %{
  remove-highlighter window/number-toggle
  evaluate-commands %sh{
    echo "add-highlighter window/number-toggle number-lines $kak_opt_number_toggle_params"
  }
}

hook global ModeChange insert:normal %{
  remove-highlighter window/number-toggle
  evaluate-commands %sh{
    echo "add-highlighter window/number-toggle number-lines -relative $kak_opt_number_toggle_params"
  }
}
