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
if [ $target = gaea ]; then
  cmake .. -DCMAKE_BUILD_TYPE=Debug -DCMAKE_Fortran_COMPILER=ftn -DCMAKE_C_COMPILER=cc
else
  cmake .. -DCMAKE_BUILD_TYPE=Debug -DCMAKE_Fortran_COMPILER=ifx -DCMAKE_C_COMPILER=icx
fi

# compile
make VERBOSE=1

if [ $? -eq 0 ]; then
  echo "COMPILATION SUCCESSFUL"
else
  echo "COMPILATION ERROR"
fi

# back out of build directory
cd ..
exit
