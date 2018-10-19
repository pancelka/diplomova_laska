#!/bin/bash

TMP=tmp.tex

for NUM in `seq -w 04 33`
do
	FILE=seminars/seminar$NUM.tex

	cat $TMP | head -1 >$FILE
	cat $TMP | tail -n +2 | grep "{Seminár" -m1 -B500 | head -n -1 >>$FILE
	cat $TMP | tail -n +2 | grep "{Seminár" -A500 >${TMP}.2
	mv ${TMP}.2 $TMP
	echo "\\input{seminars/seminar$NUM.tex}"
done
