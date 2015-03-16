#!/bin/bash

set -x
set -e

svndate=${BUILD_SVNDATE:-20150312}
tlptexlivedate=20150312

trap cleanup EXIT
cleanup(){
    rm -rf texlive-source-${svndate}
    rm -f /tmp/binaries.zip
}

cleanup

xlst=(
    i686
    ppc
    x86_64
)
for x in ${xlst[@]}; do 
    rm -rf texlive-source-${svndate}
    tar -xf ../texlive-source-${svndate}.tar.xz

    BUILD_ARCH=${x} MAKEFLAGS="-j4" BUILD_NORSYNC=1 \
              BUILD_SOURCE=$(pwd)/texlive-source-${svndate} \
              ./build-ptexlive-binaries --macosx 2>&1 | tee ${x}-darwin.log
done

./make-universal-darwin.sh
mv /tmp/binaries.zip ../binaries-darwin-${tlptexlivedate}.${svndate}.zip

exit
