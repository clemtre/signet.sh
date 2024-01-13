#!/bin/bash

dmenu_style() {
    local font='junicode-18'
    local normal_bg='#000000'
    local normal_fg='#FFFFFF'
    local selected_bg='#AAAAAA'
    local selected_fg='#000000'

    echo "-fn $font -nb $normal_bg -nf $normal_fg -sb $selected_bg -sf $selected_fg"
}

# Make it POSIX friendlier and run with #!/bin/sh

BOOKMARKS="BOOKMARKS"

url=$(xclip -o -selection clipboard)

url_regex="^(https?|ftp|file)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]*[-A-Za-z0-9+&@#/%=~_|]"

# If the given string ressembles to a url, continue.
if [[ $url =~ $url_regex ]]; then
    echo "The string is a URL: $url"
    url=$(xclip -o -selection clipboard | dmenu -p "Enter the URL:" $(dmenu_style))

    # what we used to need htmlq for :
    #name=$(curl $url | ~/.cargo/bin/htmlq title --text | sed -r '/^\s*$/d' | sed 's/^ *//g')

    # This is a blocking process and will pause the programm in case
    # internet shuts :^)
    name=$(curl $url awk -v RS='</title>' '
    /<title>/ {gsub(/.*<title>/, ""); print}
    ' $url | tr -d '\n')

    description=$(echo "" | dmenu -p "Enter a description:" $(dmenu_style))
    tags=$(echo "" | dmenu -p "Enter comma-separated tags:" $(dmenu_style))
    
    bookmark_file="$BOOKMARKS"

    # Save the data to the file. 
    echo "URL: $url" >> "$BOOKMARKS"
    echo "Name: $name" >> "$BOOKMARKS"
    echo "Description: $description" >> "$BOOKMARKS"
    echo "Tags: $tags" >> "$BOOKMARKS"
    echo "Date: $(date +%s)" >> "$BOOKMARKS"
    echo  >> "$BOOKMARKS"

else
    xclip -o -selection clipboard | dmenu -p "≉" $(dmenu_style)
fi

