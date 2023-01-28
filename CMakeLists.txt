cmake_minimum_required(VERSION 3.15)

# Define this CMake project
project(
    GFDL-VortexTracker
    DESCRIPTION "The GFDL vortex tracker created by Tim Marchok"
    HOMEPAGE_URL https://github.com/NOAA-GFDL/GFDL-VortexTracker
    VERSION 1.0.0
    LANGUAGES C Fortran
)

# Location of additional CMake modules
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

include(GNUInstallDirs)

# Executable to build, and source required
add_executable(
    gettrk
    gettrk_main.f
    gettrk_modules.f
    module_waitfor.f
    cwaitfor.c
)
install(
    TARGETS
    gettrk
)

# Find required libraries for the build
find_package(NetCDF
    4.7.4
    REQUIRED
    C Fortran
)

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

# Libraries to link for executable
target_link_libraries(gettrk bacio::bacio_4 w3emc::w3emc_4 g2::g2_4 NetCDF::NetCDF_Fortran)
