#!/bin/bash

FILE=build-web/version.js

JS_BEGIN="document.write('"
JS_END="');"
DATE=`git log -1 --date=short --format=%cd`
COMMIT_SHORT=`git rev-parse --short HEAD`
COMMIT_FULL=`git rev-parse HEAD`
URL="https://github.com/pancelka/diplomova_laska/commit/"$COMMIT_FULL

echo -n $JS_BEGIN > $FILE
echo -n "Verze: "$DATE" (commit <a target=\"_blank\" href=\""$URL"\">"$COMMIT_SHORT"</a>)" >> $FILE
echo $JS_END >> $FILE