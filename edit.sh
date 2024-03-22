#!/bin/bash

sanitize() {
	local s="${1?need a string}" # receive input in first argument
    s=$(echo $s | sed -E 's/^\s*.*:\/\///g')
	s="${s//[^[:alnum:]]/-}"     # replace all non-alnum characters to -
	s="${s//+(-)/-}"             # convert multiple - to single -
	s="${s/#-}"                  # remove - from start
	s="${s/%-}"                  # remove - from end
	echo "${s,,}"                # convert to lowercase
}

URL=$(awk '/^URL:/ {print $2}' signet)
URL_safe=$(sanitize $URL)
echo $URL_safe
curl $URL > "sac/pages/$URL_safe"
cat <<- EOF > BOOKMARKS
$(awk '/^[0-9]+$/ { print $0 + 1; exit }' BOOKMARKS)
Name: $(awk -v RS='</title>' '\
/<title>/ {gsub(/.*<title>/, ""); print}\
' sac/pages/$URL_safe | tr -d '\n')
$(cat signet BOOKMARKS)
EOF

#rm signet



