@echo on

%PYTHON% %RECIPE_DIR%\builder.py

dir "C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\"

if errorlevel 1 exit 1
