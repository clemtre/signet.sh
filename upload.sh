#!/bin/bash

# send the generated index.html over ftp 
curl -T index.html -u USER:PASSWORD ftp://ftp.SERVER/subpath/in/your/site/ -v

