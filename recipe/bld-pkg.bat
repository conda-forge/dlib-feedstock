@echo on

for /f "tokens=* usebackq" %%f in (`where cl.exe`) do (set "dummy=%%f" && call set "CXX=%%dummy:\=\\%%")

echo %CXX%

for /f "tokens=* usebackq" %%f in (`where cl.exe`) do (set "dummy=%%f" && call set "CC=%%dummy:\=\\%%")

echo %CC%

set VS170COMNTOOLS=C:\Program Files\Microsoft Visual Studio\2022\Enterprise\Common7\Tools\

dir "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\Common7\Tools\"

%PYTHON% %RECIPE_DIR%\builder.py

if errorlevel 1 exit 1
