# set up module environment on ppan

module use /app/spack/2024.02/modulefiles/linux-rhel8-x86_64

module load intel-oneapi-compilers/2024.2.1

module load cmake/3.30.5

module load hdf5/1.14.5
module load netcdf-c/4.9.2
module load netcdf-fortran/4.6.1 

module load libpng/1.6.39
module load jasper/4.2.4
module load zlib-ng/2.2.1
module load g2/3.5.1
module load g2tmpl/1.13.0
module load bacio/2.6.0 
module load w3emc/2.12.0

module load nco/5.2.4 
module load cdo/2.4.4

export ncdump=/app/spack/2024.02/linux-rhel8-x86_64/oneapi-2024.1.0/netcdf-c/4.9.2-x3z2nqyag7fyz5pyepvwge5ldeeez5di/bin/ncdump
