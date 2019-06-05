#!/bin/bash

set +x

find . -type f -name "CMakeLists.txt" -print0 | xargs -0 sed -i.bak "s/cmake_minimum_required(VERSION 2.8.12)/cmake_minimum_required(VERSION 3.5)/g"

echo "$(echo "cmake_policy(SET CMP0025 NEW)"; cat CMakeLists.txt)" > CMakeLists.txt

rm -fr build
mkdir -p build
cd build

if [ $PY3K -eq 1 ]; then
  export PY_STR="${PY_VER}m"
else
  export PY_STR="${PY_VER}"
fi

# Make the probably sensible assumption that a 64-bit
# machine supports SSE4 instructions - if this becomes
# a problem we should turn this off.
if [ $ARCH -eq 64 ]; then
  USE_SSE4=1
else
  USE_SSE4=0
fi


PYTHON_LIBRARY_PATH="$PREFIX/lib/libpython$PY_STR$SHLIB_EXT"

cmake -LAH ../tools/python                              \
  -DCMAKE_PREFIX_PATH="$PREFIX"                         \
  -DCMAKE_BUILD_TYPE="Release"                          \
  -DPYTHON_EXECUTABLE="$PYTHON"                         \
  -DPYTHON_LIBRARY="$PYTHON_LIBRARY_PATH"               \
  -DPYTHON_INCLUDE_DIR="$PREFIX/include/python$PY_STR"  \
  -DDLIB_PNG_SUPPORT=1                                  \
  -DPNG_INCLUDE_DIR="$PREFIX/include"                   \
  -DPNG_PNG_INCLUDE_DIR="$PREFIX/include"               \
  -DPNG_LIBRARY="$PREFIX/lib/libpng$SHLIB_EXT"          \
  -DZLIB_INCLUDE_DIRS="$PREFIX/include"                 \
  -DZLIB_LIBRARIES="$PREFIX/lib/libz$SHLIB_EXT"         \
  -DDLIB_JPEG_SUPPORT=1                                 \
  -DJPEG_INCLUDE_DIR="$PREFIX/include"                  \
  -DJPEG_LIBRARY="$PREFIX/lib/libjpeg$SHLIB_EXT"        \
  -DDLIB_LINK_WITH_SQLITE3=1                            \
  -DDLIB_NO_GUI_SUPPORT=1                               \
  -DUSE_SSE2_INSTRUCTIONS=1                             \
  -DUSE_SSE4_INSTRUCTIONS=$USE_SSE4                     \
  -DUSE_AVX_INSTRUCTIONS=0                              \
  -DDLIB_USE_BLAS=1                                     \
  -DDLIB_USE_LAPACK=1                                   \
  -DDLIB_USE_CUDA=0                                     \
  -DDLIB_GIF_SUPPORT=0

make -j$CPU_COUNT
# Non-standard installation - copy manually
cp dlib*.so $SP_DIR
