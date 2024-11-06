# set up module environment on hera

module load intel//2022.1.2

module use /scratch1/NCEPDEV/nems/role.epic/spack-stack/spack-stack-1.6.0/envs/unified-env-rocky8/install/modulefiles/Core/
module load stack-intel

module load cmake/3.28.1

module load hdf5
module load netcdf
module load jasper
module load zlib
module load libpng
module load g2
module load g2tmpl
module load w3emc

module load nco
module load cdo

export ncdump=/apps/netcdf/4.7.0/intel/18.0.5.274/bin/ncdump

# for grib data
module load grib-util
module load wgrib/1.8.1.0b
module load wgrib2/2.0.8
