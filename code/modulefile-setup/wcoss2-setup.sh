# set up module environment for wcoss2

module load envvar/1.0
module load PrgEnv-intel/8.3.3
module load intel-oneapi/2022.2.0.262

module load cmake/3.20.2

module load hdf5/1.10.6
module load netcdf/4.7.4
module load jasper/2.0.25
module load zlib/1.2.11
module load libpng/1.6.37
module load g2/3.5.1
module load g2tmpl/1.13.0
module load bacio/2.4.1
module load w3emc/2.12.0

module load nco/4.7.9
module load cdo/1.9.8

export ncdump=/apps/prod/hpc-stack/intel-19.1.3.304/netcdf/4.7.4/bin/ncdump


# for grib data
module load libjpeg/9c
module load grib_util/1.2.2
module load wgrib2/2.0.8_wmo 
