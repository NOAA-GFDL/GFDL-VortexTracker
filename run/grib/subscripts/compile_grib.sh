# -------------------------------------------------------------------------------------------------
# BUILD & COMPILE TRACKER EXECUTABLES

# create build directory & move into it
export builddir=${codedir}/build
if [ ! -d ${builddir} ]; then mkdir -p ${builddir}; fi
cd ${builddir}

# remove contents of build dir for fresh compilation
if [ -d ${builddir} ]; then rm -rf {*,*}; fi

# determine which system user is on
if [ -z ${which_system} ]; then              # blank
  echo "not using known rdhpc system; not using docker image"
elif [ ${which_system} = "docker" ]; then    # using container
  echo "running inside container"
else                                         # using rdhpc system
  export modsetup=${codedir}/modulefile-setup
  cd ${modsetup}
  source ${which_system}-setup.sh
  module list
fi

# build & compile source code
if [ ${which_system} = "gaea" ]; then
  cmake .. -DCMAKE_Fortran_COMPILER=ftn -DCMAKE_C_COMPILER=cc
elif [ ${which_system} = "analysis" ] \
  || [ ${which_system} = "hera" ]     \
  || [ ${which_system} = "hercules" ] \
  || [ ${which_system} = "jet" ]      \
  || [ ${which_system} = "orion" ]    \
  || [ ${which_system} = "ursa" ]     \
  || [ ${which_system} = "wcoss2" ]; then
  cmake .. -DCMAKE_Fortran_COMPILER=ifx -DCMAKE_C_COMPILER=icx
elif [ ${which_system} = "docker" ]; then
  cmake ..
else    # not on known system
  cmake ..
fi

# compile source code
make

# add success/fail compilation message
if [ $? -eq 0 ]; then
  echo "COMPILATION SUCCESSFUL"
else
  echo "COMPILATION ERROR"
fi

# install executables in exec/ directory
make install

# move back into run directory
cd ${rundir}