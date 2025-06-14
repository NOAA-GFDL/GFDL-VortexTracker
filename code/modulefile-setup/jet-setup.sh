# set up module environment on jet

module use /contrib/spack-stack/spack-stack-1.8.0/envs/ue-intel-2021.5.0/install/modulefiles/Core/
module load stack-intel/2021.5.0
module load intel/2024.2.1

module load cmake/3.28.1
module load szip/2.1

module load hdf5/1.14.5
module load netcdf/4.7.0
module load g2/3.5.1
module load g2tmpl/1.13.0
module load jasper/2.0.32
module load zlib-ng/2.1.6
module load libpng/1.6.37
module load bacio/2.4.1
module load w3emc/2.10.0

module load nco/5.1.6
module load cdo/2.3.0

export ncdump=/apps/netcdf/4.7.0/intel/18.0.5.274/bin/ncdump

# for grib data
module load grib-util/1.4.0
module load wgrib/1.8.1.0b
module load wgrib2/3.1.2_wmo
