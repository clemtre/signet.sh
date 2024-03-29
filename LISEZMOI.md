LISEZMOI est peut être en retard sur README

**Travail en cours, si vous rencontrez un soucis ennvoyez un mail à
contact@martinlemaire.fr ou ouvrez une issue ici**

Un gestionnaire de marque-page navigable généré à partir d'une base de
donnée textuel que l'on peut utiliser en temps que page d'accueil de
navigateur

Pour essayer avec une base de données BOOKMARKS fourni en exemple :
```
curl -O https://martinlemaire.fr/signet.sh/BOOKMARKS
```
ensuite
```
chmod +x signet.sh
./signet.sh
```

Le script produit le document html suivant :

index.html
![un gestionnaire de lien navigable](https://www.martinlemaire.fr/signet.sh/demo.png)

Un extrait de la base de donnée correspondante, composée d'entrées
séparées par des sauts de lignes avec des champs clé/valeur :

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
Description: 
Tags: gui, wish, tcl
Date: 1704646543

URL: https://www.kreativekorp.com/
Name: Rebecca G. Bettencourt
Description: 
Tags: RGB, people,hide
Date: 1704648764
```
Avec cette base de données, signet colore le premier lien en rose et
cache le dernier car il contient le tag "hide"

# Présentation
## signet.sh
Signet.sh est un script shell qui transforme une base de donnée de liens
en une page web. La conversion est faite par une commande awk au sein
d'une déclaration here-doc qui est redirigé dans une page html.

J'ai créé ce script car je trouve le gestionnaire de marque-page de
firefox insatisfaisant, autant dans sa forme que dans le format utilisé
(sqlite). Ce script et les utilitaires autours proposent une 
alternative pour archiver ses navigations internet.

## Format de la base de donné
Seule une Url est requise, le reste des champs sont
facultatifs, on compte les champs suivants :
* URL : ...
* Name : Par défaut la balise </title> de la page
* Description : ...
* Tags : mots-clés séparés d'une virgule
* Date : date au format ANNÉE/MOIS/JOUR de l'ajout du lien 
* Color : couleur css (nom, hex, rgb etc...)
 
## structure de la page index.html générée par signet.sh 
```
<!DOCTYPE html>
<html>
    <head>
        <title>⛵ → YY-MM-DD, H:M</title>
        <script defer src="script.js"></script>
        <link rel="stylesheet" href="style.css">
        <meta charset="utf-8" />
    </head>
    <body>
    <textarea autofocus></textarea>
    <nav>
        <p>tag (quantité)</p>
    </nav>
    <ol>
        <li>
            <a href="URL">
                <section color="Color">
                    <h5>URL</h5>
                    <h1>Name</h1>
                    <h2>Description</h2>
                    <h3>Tags</h3>
                    <h4>Date</h4>
                </section>
            <a>
        </li>
    </ol>
    <footer></footer>
    </body>
</html>
```

# Usage 
## Ajouter un marque-page :

Pour ajouter un lien, je séléctionne l'url de la page avec Ctrl + l, la
copie et lance add.sh avec Super + i. 

_Si quelqu'un sait récupérer l'url de la page courante du navigateur
sans avoir à la copier, ça économiserait deux étapes sur trois._

En résumé : Ctrl + l, Ctrl + c, Super + i

(ou plus court : Ctrl + l + c, Super + i)

Super + i car dans le fichier de configuration de mon gestionnaire de
fenêtre situé dans ~/.config/awesome/rc.lua j'ai les lignes suivantes :
```
awful.key({modkey}, "i", function()
awful.util.spawn_with_shell("add.sh") end, 
{description = "Enregistre le lien copié dans signet.sh"}),
```

# Dependance~~s~~ :
Pour ajouter un lien via l'interface proposée, on aura besoin
d'installer dmenu ~~et htmlq~~.
* dmenu https://tools.suckless.org/dmenu/ (MIT/X)
* ~~htmlq https://github.com/mgdm/htmlq (MIT)~~ remplacé par une
  commande awk
## dmenu
Dmenu est un menu interactif qui permet de sélectionner et d'écrire des
valeurs dans un menu. Ces valeurs peuvent provenir d'un programme
fournit en entrée un *pipe* "|", par exemple :
```
ls | dmenu
```
affiche un menu déroulant avec les fichiers de mon répertoire. Dans
notre script, pour stocker le choix dans une variable, on peut faire :
```
tags=$(echo "" | dmenu -p "Enter comma-separated tags:")
```
## ~~htmlq~~
Htmlq est un parseur d'html écrit en go. Peu importe quel parseur on
utilise, on dirait que chaque langage a le sien.
Il s'agit ici de fournir au programme une chaîne de caractère en entrée
et d'en filtrer des éléments html
Si en javascript pour récupérer tous les \<h1> enfants d'une \<section> on
peut faire 
```
document.querySelectorAll('section h1')
```
En shell, c'est plus compliqué, htmlq est fait pour ça :
```
cat fichier.html | htmlq 'section h1'
```
Et pour récurer seulement le texte -- l'équivalent en javascript de
.innerHTML :
```
cat fichier.html | htmlq 'section h1' --text
```
On s'en sert pour récupérer la balise titre de la page à ajouter :
```
curl page.html | htmlq 'title' --text
```
Patch pré-sortie :
```
curl $url | awk -v RS='</title>' \
    '/<title>/ {gsub(/.*<title>/, ""); print}' |\
    tr -d '\n'
```

Pour l'instant cette étape est bloquante. Pour peu que la connection
internet coupe lors de l'ajout d'un lien, il faudra attendre la fin de
la tentative de curl pour passer au prochain champs du script :/ sorry !

# Structure du répertoire

* BOOKMARKS   → Une base de données de liens 
* add.sh      → Un script pour rajouter un lien dans la base de données
  * dmenu
  * ./signet.sh
* signet.sh   → Le script shell qui lit BOOKMARKS et génère index.html
* style.css   → La feuille de style pour styliser index.html
* index.html  → C'est la page html générée. Elle est composée de :
    * \<textarea> pour chercher dans les marque-pages (ctrl + f)
    * \<section> de tags \<p> et leurs quantités rangés dans l'ordre décroissant
    * OBSOLÈTE → liste ordonnée croissante \<table> en flex column-reverse de liens <\li>
        * \<a> lien (href)
        * \<h1> Name
        * \<h2> Description
        * \<h3> Tags
        * \<h4> Date
        * \<h5> lien (texte)
     
* script.js   → Un peu de javascript pour:
  * rechercher dans la \<textarea>
  * ajouter les couleurs de fond aux entrées qui en ont

# Autres gestionnaires de marque-pages :
- nb https://xwmx.github.io/nb/ (AGPL-3.0)
- ??

# Crédits 
* Junicode (OFL-1.1)
https://psb1558.github.io/Junicode-font/
* dmenu (MIT/X) 
https://tools.suckless.org/dmenu/

