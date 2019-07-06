#!/bin/bash

######

set -e

######

ATS2VER=$1
ATS2PKG=\
ATS2-Postiats-$ATS2VER
ATS2PKGTGZ=$ATS2PKG.tgz

######

ATSLANGURL_srcfg=\
https://sourceforge.net/projects/ats2-lang

######

TARZX="tar zx"
WGETQ="wget -q"

######

ATSLANGURL_download=\
"\
${ATSLANGURL_srcfg}/files\
/ats2-lang/ats2-postiats-$ATS2VER/$ATS2PKGTGZ"

######

ATS2HOME=$2 # =${PATSHOME}

######

mkdir -p $ATS2HOME

######

( \
cd $HOME && \
$WGETQ -O- $ATSLANGURL_download | $TARZX -C $ATS2HOME --strip 1)

######

(cd $ATS2HOME && ./configure && make all)

######

###### end of [install-ats2.sh] ######
