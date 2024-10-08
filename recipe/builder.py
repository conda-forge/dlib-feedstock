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

    cuda_version = os.environ.get('cuda_compiler_version', None)
    target_platform = os.environ.get('target_platform', None)

    try:
        float(cuda_version)
        is_cuda = True
    except (TypeError, ValueError):
        is_cuda = False

    if WIN:
        cmake_args = (
            "-G Ninja\n"
            "-DDLIB_FORCE_MSVC_STATIC_RUNTIME=OFF\n"
            "-DDLIB_LINK_WITH_SQLITE3=OFF\n"
            "-DBUILD_SHARED_LIBS=ON\n"
            "-DDLIB_IN_PROJECT_BUILD=ON\n"
        ).format(**os.environ)
    else:
        cmake_args = (
            "-G Ninja\n"
            "-DJPEG_INCLUDE_DIR={PREFIX}/include\n"
            "-DPNG_PNG_INCLUDE_DIR={PREFIX}/include\n"
            "-DPNG_INCLUDE_DIR={PREFIX}/include\n"
            "-Dsqlite_path={PREFIX}/include\n"
            "-DBUILD_SHARED_LIBS=ON\n"
            "-DDLIB_IN_PROJECT_BUILD=ON\n"
        ).format(**os.environ)

    if is_cuda:
        cmake_args += "-DCMAKE_CUDA_ARCHITECTURES=all\n"
    if target_platform == "osx-arm64":
        cmake_args += "-DUSE_NEON_INSTRUCTIONS=OFF\n"

    env = dict(os.environ)
    env[PATCH_ENV_VAR] = cmake_args + os.environ.get("CMAKE_ARGS", "").replace(" ", "\n")
    # Some CUDA code doesn't compile with C++17 features and NVCC. C++11 works.
    for env_flags in ["CXXFLAGS", "DEBUG_CXXFLAGS"]:
        if env_flags in os.environ:
            env[env_flags] = os.environ.get(env_flags).replace("-std=c++17", "-std=c++11")
            env[env_flags] = os.environ.get(env_flags).replace("-std=c++14", "-std=c++11")
    print("Added to environment:\n{} = {}".format(
        PATCH_ENV_VAR,
        "".join(cmake_args)
    ), flush=True)

    return subprocess.call(
        [sys.executable, "-m", "pip", "install", ".", "-vv",
            "--no-build-isolation", "--no-deps", "--cache-dir", "pip_cache", "--no-index"],
        cwd=os.environ["SRC_DIR"],
        env=env
    )

if __name__ == "__main__":
    sys.exit(install())
