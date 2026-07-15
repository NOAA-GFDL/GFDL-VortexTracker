#!/bin/bash

# This script sets up an environment configured to load the necessary modules
# for compiling and running the Vortex Tracker on URSA with GNU.
# Last modified on: 04/09/2026
# -------------------------------------------------------------------

# reset to default module env before loading tracker module env
module purge

module use /contrib/spack-stack/spack-stack-1.9.3/envs/ue-gcc-12.4.0/install/modulefiles/Core/
module load stack-gcc/12.4.0
module load gcc//12.4.0 

module load cmake/3.30.2

module load hdf5/1.14.3
module load netcdf-c/4.9.2
module load netcdf-fortran/4.6.1

module load zlib/1.2.13
module load libpng/1.6.37
module load g2c/2.1.0
module load g2/3.5.1
module load g2tmpl/1.13.0
module load jasper/2.0.32
module load bacio/2.4.1
module load w3emc/2.10.0

# netcdf specific libs
module load nco/5.2.4
module load cdo/2.4.2
export ncdump=/apps/spack-2024-12/linux-rocky9-x86_64/gcc-11.4.1/netcdf-c-4.9.2-dzmdg3ly7avioysvapk37klgegbsq3js/bin/ncdump

# grib specific data
module load grib-util/1.5.0
module load wgrib2/3.1.3_wmo

# set flags for compilations
export FC=gfortran
export CC=gcc