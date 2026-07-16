#!/bin/bash

# This script sets up an environment configured to load the necessary modules
# for compiling and running the Vortex Tracker on ORION with Intel.
# Last modified on: 04/09/2026
# -------------------------------------------------------------------

# reset to default module env before loading tracker module env
module purge

module use /apps/contrib/spack-stack/spack-stack-1.9.3/envs/ue-oneapi-2024.2.1/install/modulefiles/Core/
module load stack-oneapi/2024.2.1
module load intel-oneapi-compilers/2024.2.1

module load cmake/3.30.2

module load netcdf-c/4.9.2
module load netcdf-fortran/4.6.1
module load hdf5/1.14.3

module load zlib-ng/2.2.1
module load zlib/1.2.13
module load g2c/2.1.0
module load g2/3.5.1
module load g2tmpl/1.13.0
module load libpng/1.6.37
module load jasper/2.0.32
module load bacio/2.4.1
module load w3emc/2.10.0

# netcdf specific libs
module load nco/5.1.6
module load cdo/2.4.3 
export ncdump=/apps/spack-managed-x86_64_v3-v1.0/oneapi-2024.2.1/netcdf-c-4.9.2-ycdpmtwmezmrc3w7gkxly2teu5poaixs/bin/ncdump

# grib specific libs
module load grib-util/1.4.0
module load wgrib2/3.1.1

# set flags for compilations
export FC=ifx
export CC=icx