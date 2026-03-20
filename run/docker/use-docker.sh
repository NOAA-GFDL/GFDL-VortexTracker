# -------------------------------------------------------------------------------------------------
# CHECK TO SEE IF USER IS RUNNING IN CONTAINER
set -x

# Check if user's run directory is set to netcdf or grib
if [[ -n ${rundir} && -d ${rundir} ]]; then
  echo "Your run directory is: ${rundir}"
  export usencdf=${homedir}/run/netcdf
  export usegrib=${homedir}/run/grib
else
  echo "The run directory does not exist or is empty"
fi

# Check expected input data file type
if [ ${rundir} == ${usencdf} ]; then
  echo "RUNNING WITH NETCDF DATA"
else
  echo "RUNNING WITH GRIB DATA"
fi

set +x