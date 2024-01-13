#!/bin/sh

dmenu_style() {
    local font='junicode-18'
    local normal_bg='#000000'
    local normal_fg='#FFFFFF'
    local selected_bg='#AAAAAA'
    local selected_fg='#000000'
    echo "-fn $font -nb $normal_bg -nf $normal_fg -sb $selected_bg -sf $selected_fg"
}

BOOKMARKS="BOOKMARKS"

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
# incrementing id soon to be implemented replacing <ol> counter
#PREV_URL_COUNT=$(grep "URL: " $BOOKMARKS | wc -l)
#ID: $((PREV_URL_COUNT + 1))
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
