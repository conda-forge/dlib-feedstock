
mkdir build && cd build

cmake -LAH -G"NMake Makefiles"                ^
  -DCMAKE_BUILD_TYPE=Release                  ^
  -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%"      ^
  -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%"   ^
  -DDLIB_LINK_WITH_SQLITE3=OFF                ^
  ../tools/python
if errorlevel 1 exit 1

cmake --build .
if errorlevel 1 exit 1

xcopy "*.pyd" "%SP_DIR%" /y
if errorlevel 1 exit 1
