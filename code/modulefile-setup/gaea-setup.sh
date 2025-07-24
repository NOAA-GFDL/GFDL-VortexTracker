# set up module environment on gaea

module use /ncrc/proj/epic/spack-stack/spack-stack-1.8.0/envs/ue-intel-2021.10.0/install/modulefiles/Core/
module load stack-intel/2023.2.0

module load cray-hdf5/1.14.3.5
module load cray-netcdf/4.9.0.13
module unload cray-libsci/25.03.0

module load libpng/1.6.37
module load jasper/2.0.32
module load zlib-ng/2.1.6
module load g2/3.5.1
module load g2tmpl/1.13.0
module load bacio/2.4.1
module load w3emc/2.10.0

module load nco/5.1.9
module load cdo/2.3.0-omp

export ncdump=/opt/cray/pe/netcdf/4.9.0.13/bin/ncdump

# for grib data
module load grib-util/1.4.0
module load wgrib/1.8.5
module load wgrib2/3.1.1

