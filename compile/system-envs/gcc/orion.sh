#!/bin/bash

# This script sets up an environment configured to load the necessary modules
# for compiling and running the Vortex Tracker on ORION with GNU.
# Last modified on: 04/09/2026
# -------------------------------------------------------------------

# reset to default module env before loading tracker module env
module purge

module use /apps/contrib/spack-stack/spack-stack-1.8.0/envs/ue-gcc-12.2.0/install/modulefiles/Core/
module load stack-gcc/12.2.0
module load gcc/12.2.0

module load cmake/3.27.9

module load netcdf-c/4.9.0
module load netcdf-fortran/4.6.0
module load hdf5/1.12.2

module load zlib-ng/2.1.6
module load zlib/1.2.13
module load g2c/1.6.4
module load g2/3.5.1
module load g2tmpl/1.13.0
module load libpng/1.6.37
module load jasper/2.0.32
module load bacio/2.4.1
module load w3emc/2.10.0

# netcdf specific libs
module load nco/5.1.6
module load cdo/2.1.0 
export ncdump=/apps/spack-managed/gcc-12.2.0/netcdf-c-4.9.0-ye4i3j22k5zupzcncgl7fqs77gifpfio/bin/ncdump

# grib specific libs
module load grib-util/1.4.0
module load wgrib2/3.1.1

# set flags for compilations
export FC=gfortran
export CC=gcc