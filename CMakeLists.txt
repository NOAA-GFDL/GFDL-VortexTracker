cmake_minimum_required(VERSION 3.15)

project(
    GFDL-VortexTracker
    DESCRIPTION "The GFDL vortex tracker created by Tim Marchok"
    HOMEPAGE_URL https://github.com/NOAA-GFDL/GFDL-VortexTracker
    VERSION 1.0.0
    LANGUAGES C Fortran)

include(GNUInstallDirs)

add_executable(
    gettrk
    gettrk_main.f
    gettrk_modules.f
    module_waitfor.f
    cwaitfor.c
)

include_directories(
    /opt/spack/spack/opt/spack/linux-ubuntu22.04-skylake/gcc-11.3.0/netcdf-fortran-4.6.0-iihaadqa3x77h5p3otlpd3rdlcrn6yo7/include
    /opt/spack/spack/opt/spack/linux-ubuntu22.04-skylake/gcc-11.3.0/netcdf-fortran-4.6.0-iihaadqa3x77h5p3otlpd3rdlcrn6yo7/include
    /opt/spack/spack/opt/spack/linux-ubuntu22.04-skylake/gcc-11.3.0/g2-3.4.5-w6szidmxvjid7nyynqtgdbnpzmqvn7rm/include_d)


find_package(
    bacio
    CONFIG
    REQUIRED
)

find_package(
    w3emc
    CONFIG
    REQUIRED
)

find_package(
    g2
    CONFIG
    REQUIRED
)

find_library(
    netcdff
    netcdff
    REQUIRED
)
target_link_libraries(gettrk bacio::bacio_4 w3emc::w3emc_4 g2::g2_4 ${netcdff})
