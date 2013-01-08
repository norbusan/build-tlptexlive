#!/bin/bash -x

svndate=20130106

rm -rf texlive-source-${svndate}

for x in x86_64 i386 ppc; do 
    tar -xf ../texlive-source-${svndate}.tar.xz

    BUILD_ARCH=${x} MAKEFLAGS="-j4" BUILD_NORSYNC=1 BUILD_SOURCE=$(pwd)/texlive-source-${svndate} ./build-ptexlive-binaries --macosx
    rm -rf texlive-source-${svndate}
done

./make-universal-darwin.sh
cp -a /tmp/binaries.zip ../binaries-darwin-${svndate}.zip
rm -f /tmp/binaries.zip

exit
