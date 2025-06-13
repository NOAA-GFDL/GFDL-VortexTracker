# set up module environment on hercules

module use /apps/contrib/spack-stack/spack-stack-1.8.0/envs/ue-intel-2021.9.0/install/modulefiles/Core/
module load stack-intel/2021.9.0
module load intel-oneapi-compilers/2024.1.0

module load cmake/3.27.9

module load netcdf-c/4.9.0
module load hdf5/1.14.3
module load netcdf-fortran/4.6.0

module load zlib-ng/2.1.6
module load g2/3.5.1
module load g2tmpl/1.13.0
module load libpng/1.6.37
module load jasper/2.0.32
module load bacio/2.4.1
module load w3emc/2.10.0

# modules needed for netcdf
module load nco/5.0.1
# nco/5.1.6 dependent on netcdf-c/4.9.2
# all other modules in this script are dependent on netcdf-c/4.9.0
module load cdo/2.1.0 

export ncdump=/apps/spack-managed/gcc-11.3.1/netcdf-c-4.9.0-bipwinwjpefdeh7awc5amsszit367mye/bin/ncdump

# modules needed for grib
module load grib-util/1.4.0
# wgrib not available
module load wgrib2/3.1.1
