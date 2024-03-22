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
                echo "The file provided doesn't seam to exist : $1"
                exit 1
            fi
            ;;
    esac
    shift
done
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --

blanklineRecords_to_html()
{
awk -v RS= '
{
    if ($0 != "") {
        id=""
        URL=""
        DESC=""
        TAGS=""
        DATE=""
        color=""

        split($0, lines, "\n")
        for (i in lines) {
            if(lines[i] ~ /^[0-9]+$/ )   {
                id=lines[i]
            }
            split(lines[i], parts, ": ")
            field = parts[1]
            value = parts[2]

            if(field ~ /^Color/ )        {color=value}
            if(field ~ /^URL/ )          {
                URL=value
            }
            if(field ~ /^Name/ )         {NAME=value}
            if(field ~ /^Description/ )  {DESC=value}
            if(field ~ /^Tags/ )         {TAGS=value}
            if(field ~ /^Date/ )         {DATE=value}

        }

        if(color != ""){
            printf "<tr color=\"%s\">", color
        }
        else{
            printf "%s", "<tr>"
        }
        printf "<td class=\"id\">%d</td>", id

        printf "<td><a href=\"%s\">%s</a>\n", URL, NAME
        if(DESC != "") {printf "<p class=\"desc\">%s</p>\n", DESC}
        printf "</td>"
        printf "<td><p class=\"tags\">%s</p></td>\n", TAGS
        if(DATE != "") {printf "<td><date>%s</date></td>\n", DATE}

        print "</tr>"
    }
} '
}
DB=$1
cat <<- EOF
<!DOCTYPE html>
<html>
    <head>
        <title>⛵ → $(date "+%g-%m-%d, %H:%M")</title>
        <link rel="stylesheet" href="style.css">
        <script defer src="script.js"></script>

        <meta charset="utf-8" />
    </head>
    <body>
    <p>liens épinglés</p>
    <table class="PIN">
    $(
cat $DB |\
awk -v RS= '/PIN/ {print $0 "\n"}' | blanklineRecords_to_html
)

</table>
<hr>
    <textarea rows="1" autofocus placeholder="filtrer..."></textarea>
    <hr>
    <details>
    <summary>tags</summary>
    <nav>
    $(
awk '/Tags: ./ {print tolower($0)}' $DB |\
    sed -e 's/tags: //' -e 's/,/\n/g' | sed 's/^ //g' |\
    sort | uniq -cd | sort -nr |\
    awk '{print "<button count=\"" $1 "\">" $2 "</button>"}'
)
    </nav>
    </details>
<hr>

<table class="signets">
<thead><tr>
    <td>#</td>
    <td>Title, URL, description</td>
    <td>tags</td>
    <td>y/m/d<rtd>
</tr></thead>
$(
#grep "jpg$" $DB
cat $DB |\
blanklineRecords_to_html
) 
    </table>
    <footer></footer>
    </body>
</html>
EOF
