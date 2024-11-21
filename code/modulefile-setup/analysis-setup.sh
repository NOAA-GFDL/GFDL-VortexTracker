# set up module environment on ppan

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

export ncdump=/app/spack/2023.02/linux-rhel7-x86_64/intel-2021.7.1/netcdf-c/4.9.2-pvuitvtd4ixig2ldwtx2qlqkkefh4ora/bin/ncdump
