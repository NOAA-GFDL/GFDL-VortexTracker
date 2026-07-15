#!/bin/bash

# This script sets up an environment configured to load the necessary modules
# for compiling and running the Vortex Tracker on HERA with Intel.
# Last modified on: 04/09/2026
# -------------------------------------------------------------------

# reset to default module env before loading tracker module env
module purge

module use /contrib/spack-stack/spack-stack-1.9.3/envs/ue-oneapi-2024.2.1/install/modulefiles/Core/
module load stack-oneapi/2024.2.1
module load intel/2024.2.1

module load cmake/3.28.1

module load hdf5/1.10.4
module load netcdf/4.7.0
module load jasper/2.0.32
module load zlib/1.2.11
module load libpng/1.6.37
module load g2c/2.1.0
module load g2/3.5.1
module load g2tmpl/1.13.0
module load w3emc/2.10.0

# netcdf specific libs
module load nco/5.1.6
module load cdo/2.3.0
export ncdump=/apps/netcdf/4.7.0/intel/18.0.5.274/bin/ncdump

# grib specific libs
module load grib-util/1.4.0
module load wgrib/1.8.1.0b
module load wgrib2/3.1.3_wmo

# set flags for compilations
export FC=ifx
export CC=icx