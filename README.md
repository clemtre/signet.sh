*FR → LISEZMOI.md*

**Work in progress, if you encounter any issues regarding
installation or understanding what this is all about, please send an
email to contact@martinlemaire.fr or open an issue here and i'll be
happy to answer**

A browsable webpage generated from a textual database you might want to
use as a browser homepage. You can edit the database by editing the file
called BOOKMARKS or by running the provided script called
edit_bookmarks_dmenu.sh (requires dmenu). The script can be ran from the
command line but I suggest to bind it to a keystroke combination.

With the provided BOOKMARKS database :
```
chmod +x signet.sh
./signet.sh
```

It produces the following html document :

index.html
![a browsable bookmark manager](demo.png)
A sample of its corresponding textual database, in the form of blankline separated
records with key/value fields :

BOOKMARKS
```
URL: http://fileformats.archiveteam.org/wiki/HEX_(Unifont)
Name: HEX (Unifont) - Just Solve the File Format Problem
Description: 
Tags: bbb, hex
Date: 1704636690
Color: Pink

URL: http://robhagemans.github.io/monobit/
Name: Hoard of bitfonts
Description: A python tool to manipulate bitmap fonts and do format conversions
Tags: bitmap, fonts
Date: 1704639859

URL: https://en.wikipedia.org/wiki/Wish_(Unix_shell)
Name: wish (Unix shell) - Wikipedia
Description:  a Tcl interpreter extended with Tk commands for unix.
Tags: gui, wish, tcl
Date: 1704646543

URL: https://www.kreativekorp.com/
Name: Rebecca G. Bettencourt
Description: 
Tags: RGB, people, hide
Date: 1704648764
```
Given this database, signet will color the first link in pink and hide
the last one because of its "hide" tag.

# Presentation
## signet.sh
Signet.sh is a shell script parsing a bookmark database to a webpage.
It uses awk inside a here-doc declaration redirected to an html file.

I have created this script because I found the bookmarks manager from
firefox not great to use, to the point where I did not have the habit to
bookmark my browsing journeys. Firefox stores bookmarks in a sqlite
which is not human readable. Although it allows an export in json and
html, I wanted something text based and personal.

## Bookmarks database format
Only a Url is required, the rest of the fields are optional :
* URL : the url pasted from the clipboard (exits if no url given)
* Name : grabs </title> from the bookmarked page with curl
* Description : a description from the user
* Tags : comma separated keywords
* Date :  posix time of the bookmarked link 
* Color : css color (name, hex, rgb etc...)

# Usage
## Add a bookmark : 

To add a link, I select the URL of the page with Ctrl + l, then copy to
clipboard and run add.sh with Super + i. 

__If anyone knows how to retrieve the url of the current browser page
without having to copy it and send it to clipboard, this would save two
steps out of three.__

In short : Ctrl + l, Ctrl + c, Super + i

(or shorter : Ctrl + l + c, Super + i)

Super + i because in my window manager (awesomewm) configuration file
located in ~/.config/awesome/rc.lua, I have the following lines:
```
awful.key({modkey}, "i", function()
awful.util.spawn_with_shell("add.sh") end, 
{description = "Sends the link in clipboard to add.sh"}),
```
## Edit a bookmark :

Use your text editor of choice. Open the BOOKMARKS file and edit the
entry. The last entry is at the bottom.

If you use vim, with BOOKMARKS opened you can press in normal mode m +
B and it will save a mark to the file you can then access with ' + B

# Installation
Works on my machine : Ubuntu 20 LTS, it should work on any POSIX
compliant machine, macOS, linux* or bsd*. I'm curious to know how it
goes on windows :^)

clone the repo

```
git clone https://git.vvvvvvaria.org/clemtre/signet.sh.git
cd signet.sh
```

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
### install dmenu :
https://askubuntu.com/questions/828450/how-to-install-dmenu

## ~~htmlq~~
Htmlq is an HTML parser written in Go. It doesn't matter which parser we
use, it seems that each language has its own.
We give to the program an html string and it filters through it using css
selectors returning the found html elements
Using javascript, retrieving all the \<h1> children of a \<section> can
be done with :
```
document.querySelectorAll('section h1')
```
In shell, it's more complicated since we don't have document object
model we can query. Htmlq is made for that:
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

# Repository structure :

* BOOKMARKS   → A textual database of bookmarks
* edit_bookmarks_dmenu.sh → A script to add a link to the database using
  dmenu
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

# Other bookmark managers:
- nb https://xwmx.github.io/nb/ (AGPL-3.0)
- ??

# Credits 
* Junicode (OFL-1.1)
https://psb1558.github.io/Junicode-font/
* dmenu (MIT/X) 
https://tools.suckless.org/dmenu/
* jquery (MIT)
https://jquery.com/ 

