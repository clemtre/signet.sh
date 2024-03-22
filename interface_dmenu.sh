#!/bin/bash

# - - - - - - - - - - - - - - - - ARGS - - - - - - - - - - - - - - - - -
show_help() {
    printf "
Usage:
    1. Copy the desired URL to your clipboard
    2. ./interface_dmenu.sh BOOKMARKS
Options:
     --help  Display this help message"
    exit 1
}
if [ "$#" -eq 0 ]; then
    printf "Nothing happened, I need a file of bookmarks to edit."
    show_help
fi

while [ "$#" -gt 0 ]; do
    case "$1" in
        --help)
            show_help
            ;;
        -*)
            printf "Error: Unknown option: $1" >&2
            show_help
            ;;
    esac
    shift
done

dmenu_style() {
    local font='junicode-18'
    local normal_bg='#000000'
    local normal_fg='#FFFFFF'
    local selected_bg='#AAAAAA'
    local selected_fg='#000000'
    echo "-fn $font -nb $normal_bg -nf $normal_fg -sb $selected_bg -sf $selected_fg"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --

URL=$(xclip -o -selection clipboard)

if [ "${URL#"http"}" != "$URL" ]; then
    DESC=$(dmenu -p "$URL · description →" $(dmenu_style))
    TAGS=$(dmenu -p "$URL · $DESC · tags →" $(dmenu_style))

cat <<- EOF > signet
URL: $URL
Description: $DESC
Tags: $TAGS
Date: $(date +%g/%m/%d)

EOF

./edit.sh

else
    printf "Text in clipboard is not a url"
    exit
fi
