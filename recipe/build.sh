#!/bin/bash

mkdir build && cd build

cmake -LAH \
  -DCMAKE_PREFIX_PATH="$PREFIX" \
  -DCMAKE_INSTALL_PREFIX="$PREFIX" \
  -DCMAKE_INSTALL_LIBDIR=lib \
  -DCMAKE_BUILD_TYPE=Release  \
  ../tools/python 
make -j$CPU_COUNT
cp dlib*.so $SP_DIR
