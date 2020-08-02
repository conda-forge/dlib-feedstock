@echo on
%PYTHON% %RECIPE_DIR%\builder.py
if errorlevel 1 exit 1

REM previous script for posterity

REM mkdir build && cd build

REM cmake -LAH -G"NMake Makefiles"                ^
REM   -DCMAKE_BUILD_TYPE=Release                  ^
REM   -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%"      ^
REM   -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%"   ^
REM   -DDLIB_LINK_WITH_SQLITE3=OFF                ^
REM   -DDLIB_FORCE_MSVC_STATIC_RUNTIME=OFF        ^
REM   ../tools/python
REM if errorlevel 1 exit 1

REM cmake --build .
REM if errorlevel 1 exit 1

REM xcopy "*.pyd" "%SP_DIR%" /y
REM if errorlevel 1 exit 1
