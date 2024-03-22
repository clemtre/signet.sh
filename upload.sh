#!/bin/bash

# send the generated index.html over ftp 
curl -T index.html -u martinlenm:HFumHFDJFpUm ftp://ftp.cluster021.hosting.ovh.net/www/bm/ -v
