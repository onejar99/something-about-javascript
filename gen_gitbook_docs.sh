#!/bin/bash

cd book-root
docker run --rm -p 4000:4000 -v $(pwd):/gitbook onejar99/gitbook:light "gitbook install && gitbook build"

cd ../
cp docs/CNAME ./
rm -rf docs
cp -rf book-root/_book docs
rm -rf docs/book_output
cp CNAME docs/
rm CNAME
docker run --rm  -p 41002:8080 -v $(pwd)/docs:/home/app/public onejar99/nodejs-live-server:node12.16.1
