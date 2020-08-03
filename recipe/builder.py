from pathlib import Path
import subprocess
import sys
import platform
import os

WIN = platform.system() == "Windows"


def install():
    """ populate the environment variable added by setup_cmake_args.patch and
        actually install with pip
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
    env.update(DLIB_CMAKE_ARGS=cmake_args)

    return subprocess.call(
        [sys.executable, "-m", "pip", "install", ".", "-vv", "--no-deps"],
        cwd=os.environ["SRC_DIR"],
        env=env
    )

if __name__ == "__main__":
    sys.exit(install())
