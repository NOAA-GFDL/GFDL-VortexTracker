# set up module environment on jet

module use /contrib/spack-stack/spack-stack-1.8.0/envs/ue-intel-2021.5.0/install/modulefiles/Core/
module load stack-intel

module load cmake/3.28.1
module load szip

module load hdf5
module load netcdf
module load jasper
module load zlib-ng
module load libpng
module load g2
module load g2tmpl
module load bacio
module load w3emc

module load nco
module load cdo

export ncdump=/apps/netcdf/4.7.0/intel/18.0.5.274/bin/ncdump

# for grib data
module load grib-util
module load wgrib/1.8.1.0b
module load wgrib2/
