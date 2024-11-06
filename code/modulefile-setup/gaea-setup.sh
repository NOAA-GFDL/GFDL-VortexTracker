# set up module environment on gaea

module use /ncrc/proj/epic/spack-stack/spack-stack-1.6.0/envs/unified-env/install/modulefiles/Core
module load stack-intel/2023.2.0

module load cray-hdf5
module load cray-netcdf

module load libpng
module load jasper
module load zlib
module load g2
module load g2tmpl
module load bacio
module load w3emc

module load nco
module load cdo

export ncdump=/opt/cray/pe/netcdf/4.9.0.3/bin/ncdump

# for grib data
module load grib-util
module load wgrib
module load wgrib2
