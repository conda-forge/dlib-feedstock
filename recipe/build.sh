#!/bin/bash

mkdir build && cd build

cmake -LAH \
  -DCMAKE_PREFIX_PATH="$PREFIX" \
  -DCMAKE_INSTALL_PREFIX="$PREFIX" \
  -DCMAKE_INSTALL_LIBDIR=lib \
  -DCMAKE_BUILD_TYPE=Release  \
  -DPYTHON_EXECUTABLE=${PREFIX}/bin/python \
  -DJPEG_INCLUDE_DIR=${PREFIX}/include \
  -DPNG_PNG_INCLUDE_DIR=${PREFIX}/include \
  -DPNG_INCLUDE_DIR=${PREFIX}/include \
  -Dsqlite_path=${PREFIX}/include \
  ../tools/python
make -j$CPU_COUNT
cp dlib*.so $SP_DIR
