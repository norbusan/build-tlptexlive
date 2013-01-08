#!/bin/bash
# This script makes universal binaries of ix86 (i686) and ppc. 

pwd=$(pwd)

release=$(uname -r)
arch=universal-darwin${release}

rm -rf /tmp/Work
mkdir -p /tmp/Work
cd /tmp/Work
unzip /tmp/binaries.zip
[ -d i686-apple-darwin${release} ] || exit 1
mkdir -p $arch

for x in i686-apple-darwin${release}/*; do
    [ -d $x ] && continue

    ## for Mach-O executable i386
    file $x | grep -q -e "Mach-O executable i386"
    if [ $? -eq 0 -a ! -h $x ]; then
	lipo -create \
	    -arch i686 $x \
	    -arch ppc powerpc-apple-darwin${release}/$(basename $x) \
	    -output ${arch}/$(basename $x)
    else
	## for non-binaries
	if [ -h $x ]; then
	    _lnk=$(readlink $x)
	    (cd ${arch}
		ln -sf $_lnk $(basename $x)
	    )
	else
	    cp -p $x ${arch}/
	fi
    fi
done

zip -r /tmp/binaries.zip ${arch}/*

rm -rf /tmp/Work

echo "$(basename $0): done."

exit
