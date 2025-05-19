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
cmake .. -DCMAKE_BUILD_TYPE=Debug -DCMAKE_Fortran_COMPILER=ifx -DCMAKE_C_COMPILER=icx

# compile
make VERBOSE=1

echo " COMPLETE "

# back out of build directory
cd ..
exit
