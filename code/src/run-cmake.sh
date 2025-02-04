#!/bin/bash

# adds $target variable to identify which rdhpc system you're on
source machine-setup.sh

# loads any module/packages needed for cmake build
cd ../modulefile-setup
source $target-setup.sh
module list

# makes and enters build directory
cd ..
if [ -d "build" ]; then
   rm -rf build
fi
mkdir build
cd build

# build src code
if [ $target = analysisRHEL7 ]; then 	# nodes that have not been updated to RHEL8 will not compile with ifx & icx
  cmake .. -DCMAKE_Fortran_COMPILER=ifort -DCMAKE_C_COMPILER=icc
elif [ $target = gaea ]; then
  cmake .. -DCMAKE_Fortran_COMPILER=ftn -DCMAKE_C_COMPILER=cc
else
  cmake .. -DCMAKE_Fortran_COMPILER=ifx -DCMAKE_C_COMPILER=icx
fi

# compile
make

# install executables in exec/ directory
make install

# back out of build directory
cd ..
exit


