@echo on

for /f "tokens=* usebackq" %%f in (`where cl.exe`) do (set "dummy=%%f" && call set "CXX=%%dummy:\=\\%%")

echo %CXX%

for /f "tokens=* usebackq" %%f in (`where cl.exe`) do (set "dummy=%%f" && call set "CC=%%dummy:\=\\%%")

echo %CC%

%PYTHON% %RECIPE_DIR%\builder.py

if errorlevel 1 exit 1
