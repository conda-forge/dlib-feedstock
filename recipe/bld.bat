@echo on

%PYTHON% %RECIPE_DIR%\builder.py

if errorlevel 1 exit 1
