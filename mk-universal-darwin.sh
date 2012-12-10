#!/bin/bash
# This script makes universal binaries of ix86 (i686) and ppc (ppc7400). 

pwd=$(pwd)

rm -rf /tmp/Work
mkdir -p /tmp/Work
cd /tmp/Work
unzip ${pwd}/../binaries-i686-darwin-20120124.zip
unzip ${pwd}/../binaries-powerpc-darwin-20120124.zip
#unzip ${pwd}/../binaries-x86_64-darwin-20120124.zip
mkdir -p universal-darwin

for x in i686-apple-darwin11.2.0/*; do
    [ -d $x ] && continue

    ## for Mach-O executable i386
    file $x | grep -q -e "Mach-O executable i386"
    if [ $? -eq 0 -a ! -h $x ]; then
	lipo -create \
	    -arch i386 $x -arch ppc7400 powerpc-apple-darwin11.2.0/$(basename $x) \
	    -output universal-darwin/$(basename $x)
    else
	## for non-binaries
	if [ -h $x ]; then
	    _lnk=$(readlink $x)
	    (cd universal-darwin
		ln -sf $_lnk $(basename $x)
	    )
	else
	    cp -p $x universal-darwin/
	fi
    fi
done

zip -r /tmp/binaries.zip 	\
	universal-darwin/dvi2tty	\
	universal-darwin/dvipdfmx	\
	universal-darwin/eptex		\
	universal-darwin/euptex	\
	universal-darwin/makejvf	\
	universal-darwin/mendex	\
	universal-darwin/pbibtex	\
	universal-darwin/pdvitype	\
	universal-darwin/pmpost	\
	universal-darwin/ppltotf	\
	universal-darwin/ptex		\
	universal-darwin/ptftopl	\
	universal-darwin/pxdvi		\
	universal-darwin/pxdvi-xaw	\
	universal-darwin/upbibtex	\
	universal-darwin/updvitype	\
	universal-darwin/uppltotf	\
	universal-darwin/uptex		\
	universal-darwin/uptftopl	\
	universal-darwin/wovp2ovf	\
	;

echo "$(basename $0): done."

exit
