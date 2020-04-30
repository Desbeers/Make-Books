#!/bin/zsh

# Nice colours
autoload colors
if [[ "$terminfo[colors]" -gt 8 ]]; then
    colors
fi
for COLOR in RED GREEN YELLOW BLUE MAGENTA CYAN BLACK WHITE; do
    eval $COLOR='$fg_no_bold[${(L)COLOR}]'
    export $COLOR
    eval BOLD_$COLOR='$fg_bold[${(L)COLOR}]'
    export BOLD_$COLOR
done
eval RESET='$reset_color'
export RESET