#!/bin/bash -x

svndate=20130902

for x in x86_64 i686 ppc; do 
    rm -rf texlive-source-${svndate}
    tar -xf ../texlive-source-${svndate}.tar.xz

    BUILD_XCODEROOT=/Xcode3 BUILD_ARCH=${x} MAKEFLAGS="-j4" BUILD_NORSYNC=1 BUILD_SOURCE=$(pwd)/texlive-source-${svndate} ./build-ptexlive-binaries --macosx 2>&1 | tee ${x}-darwin.log
done
rm -rf texlive-source-${svndate}

./make-universal-darwin.sh
cp -a /tmp/binaries.zip ../binaries-darwin-20130815.${svndate}.zip
rm -f /tmp/binaries.zip

exit
