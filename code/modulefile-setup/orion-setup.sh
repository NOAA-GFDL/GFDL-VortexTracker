# set up module environment on orion

module load intel-oneapi-compilers
module load cmake

module use /work/noaa/epic/role-epic/spack-stack/orion/spack-stack-1.7.0/envs/ue-intel/install/modulefiles/Core
module load stack-intel

module load zlib
module load hdf5
module load netcdf-fortran
module load netcdf-c

module load libpng
module load jasper
module load g2
module load g2tmpl
module load bacio
module load w3emc

module load nco
module load cdo

export ncdump=/apps/spack-managed/oneapi-2023.1.0/netcdf-c-4.9.2-uobcixaxwcjqksw2bye4kirbvqum3ytt/bin/ncdump

# for grib data
module load grib-util
module load wgrib2
