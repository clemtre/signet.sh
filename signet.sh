#!/bin/bash

#                   ,  o  _,        __|_   ,  |)   
#                  / \_| / | /|/|  |/ |   / \_|/\  
#                   \/ |/\/|/ | |_/|_/|_/o \/ |  |/
#                         (| 

# - - - - - - - - - - - - - - - - ARGS - - - - - - - - - - - - - - - - -
show_help() {
    echo "Usage:"
    echo "  ./signet.sh BOOKMARKS > index.html"
    echo "Options:"
    echo "  --help  Display this help message"
    exit 1
}
if [ "$#" -eq 0 ]; then
    echo "Nothing happened, I need a file of bookmarks to process."
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
        *)
            if [ -f "$1" ]; then
                break
            else
                echo "The file you provided doesn't seam to exist : $1"
                exit 1
            fi
            ;;
    esac
    shift
done
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --

# I thought about using recutils db from GNU but went back to plain text
# DB=BOOKMARKS.rec
DB=$1

cat <<- EOF 
<!DOCTYPE html>
<html>
    <head>
        <title>⛵ → $(date "+%g-%m-%d, %H:%M")</title>
        <script defer src="jquery-3.7.1.slim.min.js"></script>
        <script defer src="script.js"></script>
        <link rel="stylesheet" href="style.css">
        <meta charset="utf-8" />
    </head>
    <body>
    <div id="cc"></div>
    <textarea autofocus></textarea>
    <nav>
    $(
awk '/Tags: ./ {print tolower($0)}' $DB |\
    sed -e 's/tags: //' -e 's/,/\n/g' | sed 's/^ //g' |\
    sort | uniq -c | sort -nr |\
    awk '{print "<p count=\"" $1 "\">" $2 "</p>"}'
)
    </nav>
    <ol>
$(
awk -v RS= '!/Tags: .*hide/ {print $0 "\n"}' $DB |\
awk -v RS= '
{
    if ($0 != "") {
        split($0, lines, "\n")
        color = ""
        for (i in lines) {
            split(lines[i], parts, ": ")
            field = parts[1]
            value = parts[2]
            if (field == "Color") {
                color = value
            }
            vals[i] = value 
        }
        URL=vals[1]
        NAME=vals[2]
        DESC=vals[3]
        TAGS=vals[4]
        DATE=vals[5]

        print "<li>"
        print "<a href=\"" URL "\">" 

        if (color != "") { 
            print "<section color=\"" color "\">" 
        } 
        else { 
            print "<section>" 
        }

        print "<h5>" URL  "</h5>" \
              "<h1>" NAME "</h1>" \
              "<h2>" DESC "</h2>" \
              "<h3>" TAGS "</h3>" \
              "<h4>" DATE "</h4>"

        print "</section>"
        print "</a>" 
        print "</li>"
    }
} ' 
) 
    </ol>
    <footer></footer>
    </body>
</html>
EOF
