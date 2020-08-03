from pathlib import Path
import subprocess
import sys
import platform
import os

WIN = platform.system() == "Windows"

# this is patched in by setup_cmake_args.patch
PATCH_ENV_VAR = "DLIB_CMAKE_ARGS"


def install():
    """ populate the environment variable added by the patch and actually
        install with pip
    """
    if WIN:
        cmake_args = (
            "-DDLIB_FORCE_MSVC_STATIC_RUNTIME=OFF\n"
            "-DDLIB_LINK_WITH_SQLITE3=OFF\n"
        ).format(os.environ)
    else:
        cmake_args = (
            "-DJPEG_INCLUDE_DIR={PREFIX}/include\n"
            "-DPNG_PNG_INCLUDE_DIR={PREFIX}/include\n"
            "-DPNG_INCLUDE_DIR={PREFIX}/include\n"
            "-Dsqlite_path={PREFIX}/include\n"
        ).format(**os.environ)

    env = dict(os.environ)
    env[PATCH_ENV_VAR] = cmake_args
    print("Added to environment:\n{} = {}".format(
        PATCH_ENV_VAR,
        "\t".join(cmake_args)
    ), flush=True)

    return subprocess.call(
        [sys.executable, "-m", "pip", "install", ".", "-vv", "--no-deps"],
        cwd=os.environ["SRC_DIR"],
        env=env
    )

if __name__ == "__main__":
    sys.exit(install())
