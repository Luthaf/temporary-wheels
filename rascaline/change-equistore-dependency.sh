#!/usr/bin/env bash

set -eux

rm -rf tmp

mkdir tmp
cd tmp
tar xf ../rascaline-*.tar.gz
RASCALINE_DIR=`ls`
sed -i "" -e "s|equistore @ https://github.com/lab-cosmo/equistore/archive/eb3800.zip|equistore|" ${RASCALINE_DIR}/setup.cfg
tar czf ${RASCALINE_DIR}.tar.gz ${RASCALINE_DIR}

rm -rf ${RASCALINE_DIR}

for path in `ls ../*.whl`; do
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
