# set up module environment for ursa

module use /contrib/spack-stack/spack-stack-1.9.1/envs/ue-oneapi-2024.2.1/install/modulefiles/Core
module load stack-oneapi/2024.2.1
module load intel-oneapi-compilers/2024.2.1

module load cmake/3.30.2

module load hdf5/1.14.3
module load netcdf-c/4.9.2
module load netcdf-fortran/4.6.1

module load zlib/1.2.13
module load libpng/1.6.37
module load g2/3.5.1
module load g2tmpl/1.13.0
module load jasper/2.0.32
module load bacio/2.4.1
module load w3emc/2.10.0

# modules needed for netcdf
module load nco/5.2.4
module load cdo/2.4.2

export ncdump=/apps/spack-2024-12/linux-rocky9-x86_64/oneapi-2024.2.1/netcdf-c-4.9.2-d4nrv7qasbq2sjcfevf7tnoj4pyemdlr/bin/ncdump

# modules needed for grib
module load grib-util/1.5.0
# wgrib not available
module load wgrib2/3.6.0
