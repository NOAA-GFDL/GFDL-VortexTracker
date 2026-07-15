#!/bin/bash

# This script sets up an environment configured to load the necessary modules
# for compiling and running the Vortex Tracker on PPAN with GNU.
# Last modified on: 04/09/2026
# -------------------------------------------------------------------

# reset to default module env before loading tracker module env
module purge

module use /app/spack/2026.01/lmod/linux-rhel8-x86_64/Core

module load gcc/14.3.0

module load cmake/3.31.8

module load hdf5/1.14.6
module load netcdf-c/4.9.2
module load netcdf-fortran/4.6.1

module load libpng/1.6.47
module load jasper/4.2.4
module load zlib/1.3.1
module load zlib-ng/2.2.4
module load g2c/2.1.0
module load g2/4.0.0
module load g2tmpl/1.14.0
module load bacio/2.6.0
module load w3emc/2.12.0

# netcdf specific libs
module load nco/5.3.3
module load cdo/2.5.2

# grib specific libs
module load wgrib2/3.6.0
module load grib-util/1.5.0

# set flags for compilations
export FC=gfortran
export CC=gcc