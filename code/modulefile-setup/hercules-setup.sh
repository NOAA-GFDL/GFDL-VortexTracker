# set up module environment on hercules

module load cmake

module use /work/noaa/epic/role-epic/spack-stack/hercules/spack-stack-1.7.0/envs/ue-intel/install/modulefiles/Core
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
