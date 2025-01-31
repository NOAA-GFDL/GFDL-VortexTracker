# set up module environment on ppan

module use /app/spack/2024.02/modulefiles/linux-rhel8-x86_64

module load intel-oneapi-compilers

module load cmake

module load hdf5
module load netcdf-c
module load netcdf-fortran

module load libpng
module load jasper
module load zlib
module load g2
module load g2tmpl
module load bacio
module load w3emc

module load nco
module load cdo

export ncdump=/app/spack/2024.02/linux-rhel8-x86_64/oneapi-2024.1.0/netcdf-c/4.9.2-x3z2nqyag7fyz5pyepvwge5ldeeez5di/bin/ncdump