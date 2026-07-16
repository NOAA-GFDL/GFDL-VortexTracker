#!/bin/bash

# This script sets up an environment configured to load the necessary modules
# for compiling and running the Vortex Tracker on WCOSS2 with Intel.
# Last modified on: 04/09/2026
# -------------------------------------------------------------------

# reset to default module env before loading tracker module env
module reset

module load PrgEnv-intel/8.5.0
module load intel-oneapi/2022.2.0.262

module load cmake/3.20.2

module load hdf5/1.10.6
module load netcdf/4.7.4
module load jasper/2.0.25
module load zlib/1.2.11
module load libpng/1.6.37
module load g2c/2.3.0
module load g2/3.5.1
module load g2tmpl/1.17.0
module load bacio/2.4.1
module load w3emc/2.12.0

# netcdf specific libs
module load nco/5.2.4
module load cdo/1.9.8
export ncdump=/apps/prod/hpc-stack/intel-19.1.3.304/netcdf/4.7.4/bin/ncdump

# grib specific libs
module load grib_util/1.5.0
module load wgrib2/2.0.8_wmo

# set flags for compilations
export FC=ifx
export CC=icx