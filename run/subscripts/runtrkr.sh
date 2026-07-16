#!/bin/bash

# print line numbers in std out
export PS4=' line $LINENO: '
set -x

export tmpdir=${PWD%/*/*}/work/tmpfiles
source ${tmpdir}/compileinputs.txt
source ${tmpdir}/userinputs.txt

# -------------------------------------------------------------------------------------------------

# slice init date/time to use later in script
export pdy=`     echo ${initymdh} | cut -c1-8`
export yyyy=`    echo ${initymdh} | cut -c1-4`
export cc=`      echo ${initymdh} | cut -c1-2`
export yy=`      echo ${initymdh} | cut -c3-4`
export mm=`      echo ${initymdh} | cut -c5-6`
export dd=`      echo ${initymdh} | cut -c7-8`
export hh=`      echo ${initymdh} | cut -c9-10`
export ymdh=${initymdh}

# set date stamp vars
export date_stamp=$(date +"%a %b %d %H:%M:%S %Z %Y")
export today_stamp=$(date +"%b%d-%H.%M%p")

# set wdir path
export wdir=${workdir}/${today_stamp}/${atcfname}.${pdy}
if [ ! -d ${wdir} ]; then mkdir -p ${wdir}; fi

set +x
# -------------------------------------------------------------------------------------------------
# INVOKE SCRIPTS

# load env modules 
source ${compdir}/system-envs/${compiler}/${system}.sh

# list modules
echo -e " "
module list

if [ ${datatype} = 'netcdf' ]; then
  export atmosvars=${PWD}/atmos_${datatype}vars.sh
  source ${atmosvars}
  if [ ${usercheck} != 'CHECKED' ]; then
    echo -e " "
	  echo -e "** USER CHECK FAILED**"
	  echo -e "Please return to: "
    echo -e "\t${atmosvars}"
    echo -e "\tand ensure all variables are declared accordingly"
    echo -e " "
    echo -e "Documentation and additional instructions can be found here: "
		echo -e "\t<add link here when ready>"
		echo -e " "
		echo -e "If a you are experiencing other complications please open an issue via GitHub"
		echo -e "Issues can be created here: https://github.com/NOAA-GFDL/GFDL-VortexTracker/issues/new"
		echo -e " "
	  echo -e " "
	  exit 0
  fi  
fi

source ${subdir}/${datatype}_vars.sh

export vitalsdir=${subdir}/archived_vitals
source ${subdir}/make_tcvitals.sh

source ${subdir}/namelist.sh 

source ${subdir}/IOfiles.sh

# print tracker set up is finished
echo "TRACKER SET UP FINISHED"

# -------------------------------------------------------------------------------------------------
# EXECUTE TRACKER SOURCE CODE

echo "INITIALIZE TRACKER EXECUTABLE"
echo "Running tracker for ${atcfname} at ${hh}z at ${date_stamp}"

${execdir}/gettrk.x
export gettrk_rcc=$?

echo "After tracker source code run  ---> ${date_stamp}"
echo "Return code from tracker= gettrk_rcc= ${gettrk_rcc}"

# add print statement if tracker completed successfully
if [ ${gettrk_rcc} -gt 0 ]; then
  echo "TRACKER DID NOT RUN TO COMPLETION"
  exit 1
else
  echo "TRACKER RAN SUCCESSFULLY"
fi

exit 0