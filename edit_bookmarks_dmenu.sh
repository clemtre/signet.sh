#!/bin/sh

# needs a better name

# - - - - - - - - - - - - - - - - ARGS - - - - - - - - - - - - - - - - -
show_help() {
    echo "Usage:"
    echo "1. Copy the desired Url to your clipboard"
    echo "2. ./edit_bookmarks_dmenu.sh BOOKMARKS"
    echo "Options:"
    echo "  --help  Display this help message"
    exit 1
}
if [ "$#" -eq 0 ]; then
    echo "Nothing happened, I need a file of bookmarks to edit."
    show_help
fi

while [ "$#" -gt 0 ]; do
    case "$1" in
        --help)
            show_help
            ;;
        -*)
            echo "Error: Unknown option: $1" >&2
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

# TODO : process multiple files of BOOKMARKS at once
BOOKMARKS=$1

URL=$(xclip -o -selection clipboard)

# The curl for Name: is a blocking process and will pause the programm
# in case internet shuts :^)

# TODO : 
# add description, tags and color in one field with symbols such as : 
# § this is a description. § comma, separated, tags § color

# If the given string ressembles to a url, continue.
# https://stackoverflow.com/questions/21115121/how-to-test-if-string-matches-a-regex-in-posix-shell-not-bash
# URL_REGEX="^(https?|ftp|file)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]*[-A-Za-z0-9+&@#/%=~_|]"
if printf "$URL" | grep -q http; then
# TODO : incrementing id replacing <ol> list counter
#PREV_URL_COUNT=$(grep "URL: " $BOOKMARKS | wc -l)
#ID: $((PREV_URL_COUNT + 1))
# TODO : add the bookmark in reverse, last in first first on the stack
# maybe using tac instead of cat ?
cat <<- EOF >> $BOOKMARKS

URL: $(printf $URL)
Name: $(curl $URL | awk -v RS='</title>' '\
/<title>/ {gsub(/.*<title>/, ""); print}\
' | tr -d '\n')
Description: $(printf "" | dmenu -p "Enter a description: " $(dmenu_style))
Tags: $(printf "" | dmenu -p "Enter comma separated tags: " $(dmenu_style))
Date: $(date +%s)

EOF

else
    printf "Text in clipboard is not a url"
    exit
fi

# what we used to need htmlq for :
# name=$(curl $url | ~/.cargo/bin/htmlq title --text | sed -r '/^\s*$/d' | sed 's/^ *//g')
