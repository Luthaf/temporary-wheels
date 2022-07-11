#!/usr/bin/env bash

set -eux

PATTERN=$1

if [[ ! -f $PATTERN.tar.gz ]]; then
    echo "usage: ./change-equistore-dependency.sh rascaline-<version>"
    exit 1
fi

rm -rf tmp

mkdir tmp
cd tmp
tar xf ../$PATTERN.tar.gz
RASCALINE_DIR=`ls`
sed -i "" -e "s|equistore @ https://github.com/lab-cosmo/equistore/archive/eb3800.zip|equistore|" ${RASCALINE_DIR}/setup.cfg
tar czf ${RASCALINE_DIR}.tar.gz ${RASCALINE_DIR}

rm -rf ${RASCALINE_DIR}

for path in `ls ../$PATTERN-*.whl`; do
    wheel=`basename $path`
    mkdir $wheel-dir
    cd $wheel-dir
    unzip ../$path

    sed -i "" -e "s|equistore @ https://github.com/lab-cosmo/equistore/archive/eb3800.zip|equistore|" *.dist-info/METADATA

    zip -r ../$wheel *
    cd ..

    rm -rf $wheel-dir
done

cd ..

mv tmp/* .
rm -rf tmp
