*FR → LISEZMOI.md*
# Demo
![a browsable bookmark manager](demo.png)
**Something more understendable and browsable to be released soon**

# Presentation
## signet.sh
Signet.sh is a shell script parsing a bookmark database to a webpage.
It uses awk inside a here-doc declaration redirected to an html file.

I have created this script because I found the bookmarks manager from
firefox not great to use, to the point where I did not have the habit to
bookmark my browsing. Firefox stores bookmarks in a sqlite format and I
wanted something text based.

I have been using the generated html page as a default landing page for
three months, it has been a pleasing experience so far.

## Bookmarks database format
Only a Url is required, the rest of the fields are optional :
* URL : ...
* Name : grabs </title> from the bookmarked page
* Description : ...
* Tags : comma separated keywords
* Date :  posix time of the bookmarked link
* Color : css color (name, hex, rgb etc...)

For example, in a file called BOOKMARKS by default:
```
URL: https://rosettacode.org/wiki/Rosetta_Code
Name: Rosetta Code
Description: 
Tags: literacy, read
Date: 1704675057
Color: Purple

URL: https://www.emigre.com/TypeSpecimens
Name: Emigre: Type Specimens
Description: 
Tags: emigre, type
Date: 1704680644

URL: https://web.archive.org/web/20211025182257/http://len.falken.ink/
Name: Wayback Machine
Description: 
Tags: read
Date: 1704712747
```


# Other bookmark managers:
- nb https://xwmx.github.io/nb/ (AGPL-3.0)
- ??


# Dependency :
To add a link via the proposed interface, we will need
to install dmenu ~~and htmlq~~.
* dmenu https://tools.suckless.org/dmenu/ (MIT/X)
* ~~htmlq https://github.com/mgdm/htmlq (MIT)~~ replaced by one
awk command
## dmenu
Dmenu is an interactive menu that allows us to select and write
values in a menu. These values can come from a program
provided as input from a pipe "|", for example:
```
ls | dmenu
```
displays a drop-down menu with the files in my directory. 
In our script, to store the given tags in a variable, we can do:
```
tags=$(echo "" | dmenu -p "Enter comma-separated tags:")
```
## ~~htmlq~~
Htmlq is an HTML parser written in Go. It doesn't matter which parser we
uses, it seems that each language has its own.
We give to the program an html string and it filters through it using css
selectors returning the found html elements
Using javascript, retrieving all the \<h1> children of a \<section> can
be done with :
```
document.querySelectorAll('section h1')
```
In shell, it's more complicated, htmlq is made for that:
```
cat fichier.html | htmlq 'section h1'
```
And to output only the text -- the javascript equivalent of .innerHTML:
```
cat fichier.html | htmlq 'section h1' --text
```
We use it to retrieve the title tag of the page to add:
```
curl page.html | htmlq 'title' --text
```
Pre-release patch:
```
curl $url | awk -v RS='</title>' \
    '/<title>/ {gsub(/.*<title>/, ""); print}' |\
    tr -d '\n'
```

For the moment this step is blocking. In case internet cuts while
bookmarking a link, you will have to wait for the end of the curl
attempt to move to the next field in the script :/ sorry!

# Add a bookmark : 

To add a link, I select the URL of the page with Ctrl + l, the copy and
run add.sh with Super + i. _If anyone knows how to retrieve the url of
the current browser page without having to copy it, this would save two
steps out of three._
En résumé : Ctrl + l, Ctrl + c, Super + i
(ou plus court : Ctrl + l + i, Super + i)

Super + i because in my window manager configuration file located in
~/.config/awesome/rc.lua, I have the following lines:
```
awful.key({modkey}, "i", function()
awful.util.spawn_with_shell("add.sh") end, 
{description = "Enregistre le lien copié dans signet.sh"}),
```

# Repository structure :

* BOOKMARKS   → A textual database of bookmarks
* add.sh      → A script to add a link to the database
  * dmenu
  * ./signet.sh
* bookmark.sh → The shell script itself
  * It generates a new html page from the link database
    (default index.html)
* style.css   → Stylesheet for index.html
* script.js   → A bit of javascript for:
  * search in the \<textarea>
  * add background colors to entries that have them
  * if the description field is empty, do not display it
  * format posix time dates to YY-MM-DD format
/!\ Soon /!\
starred.sh  → curl from the github user api and format it in the same
way as signet.sh without using jq
https://api.github.com/users/[user]/starred

# Credits 
Junicode (OFL-1.1)
https://psb1558.github.io/Junicode-font/
Dmenu License (MIT/X) 
https://tools.suckless.org/dmenu/

