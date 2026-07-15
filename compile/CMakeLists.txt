#----------------------------------------------------------
# Last edited by: Caitlyn Mcallister
# Originated by: Biju Thomas
# Email: caitlyn.mcallister@noaa.gov
#        timothy.marchok@noaa.gov
#----------------------------------------------------------

cmake_minimum_required(VERSION 3.15)
project(
  GFDL-VortexTracker VERSION 1.0
  DESCRIPTION "Hurricane tracker"
  LANGUAGES C Fortran)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules/")

find_package(HDF5 REQUIRED)
find_package(NetCDF REQUIRED C Fortran)
find_package(PNG REQUIRED)
find_package(Jasper REQUIRED)
find_package(ZLIB REQUIRED)
find_package(g2 REQUIRED)
find_package(bacio REQUIRED)
find_package(w3emc REQUIRED)

enable_testing()

add_subdirectory(src/support/)
add_subdirectory(src/tracker/)
