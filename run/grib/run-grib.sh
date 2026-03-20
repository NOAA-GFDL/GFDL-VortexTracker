#!/bin/bash --login
# USER - please note shell type is defaulted to bash, change if necessary
# Add batch commdands if needed, if running in container leave these lines as they are

# print line numbers in std out
export PS4=' line $LINENO: '
set -x

# -------------------------------------------------------------------------------------------------
# USER - ALL CODE IN THE SECTION BELOW WILL NEED TO BE MODIFIED;
# PLEASE TAKE TIME TO READ COMMENTS AND EDIT ACCORDINGLY

# Set directory paths
export datadir=
export homedir=

# If you already have a tcvitals file, add path and name below.
# If the file has not been created yet, leave this blank and the tcvitals_grib.sh script will create one
# Please note, our archived vitals information contains data up until 03/21/2025
export tcvitals_file=

# The following paths should not necessarily need to be modified, however they can be edited as developer wishes
# CAVEAT - if running the same case on the same day, adding an additional subdirectory to 
# the workdir path will ensure that no output files are accidentally overwritten
export rundir=${homedir}/run/grib
export codedir=${homedir}/code
export arcvitals=${homedir}/archived_vitals
export execdir=${codedir}/exec
export workdir=${rundir}/work

# Name of rdhpc system (gaea, analysis, wcoss2, etc.), docker, or blank if on personal system
export which_system=''

if [ ${which_system} = 'docker' ]; then
  export dockerdir=${homedir}/run/docker
  source ${dockerdir}/use-docker.sh
fi

# Initialization forecast date/time matching your data (yyyymmddhh format)
export initymdh=

# Add the respective forcast hours to match your data; (spaces between hrs only, no commas)
# This will be used for temperature and height interpolation
export fcsthrs=''

# trkrtype=tracker for known storms, trkrtype=tcgen for genesis runs
export trkrtype=''

# gribver=1 for GRIB1 data; gribver=2 for GRIB2 data
export gribver=

# file_sequence='multi' when there are multiple files with single frcast hour;
# file_sequenxe='onebig when all of the data is in one single file
export file_sequence=''

# ATCF name of model (4 char long)
export atcfname=''

# (Optional) This is descriptive and up to the developer (e.g., "6thdeg", "9km_run","1.6km_run", "15km_ens_run_member_n13", etc)
export rundescr=''
# (Optional) If used, it should be something that identifies the particular storm, preferably using the atcf ID.
# For example, the GFDL model standard is to use something like "ike09l", or "two02e", etc. 
export atcfdescr=''

# Variables to declare the model's grid and nesting configurations
export modtyp=''         # 'global' or 'regional'
export nest_type=''      # 'moveable' or 'fixed'

# 'vortex_tilt_flag' = 'y'/'n'
# If developer wants to run vortex tilt diagnostics, set to 'y'. If set to 'n', the following if-statement will set
# the tilt_parm and threshold variables values automatically
export vortex_tilt_flag=''
export vortex_tilt_parm=''
export vortex_tilt_allow_thresh=

if [ ${vortex_tilt_flag} = 'n' ]; then
  export vortex_tilt_parm=''
  export vortex_tilt_allow_thresh=''
else
  echo "vortex tilt diagnostics enabled"
  echo "vortex tilt parameter = ${vortex_tilt_parm}"
  echo "vortex tilt threshold = ${vortex_tilt_allow_thresh}"
fi

# 'need_to_*' = 'y'/'n'
# These variables are used to detemerine if input data needs to be interpolated; i.e. input files being used
# to run the tracker don't have data at 50mb height level (850, 750, 550, etc.).
# If 'need_to_use_vint_or_tave' set to 'y' then interpolation code will be ran within the multi or onebig scripts.
# User can determine if only height and/or temperature interpolation is calculated determined by the value of the following variables
export need_to_use_vint_or_tave=''
export need_to_interpolate_height=''
export need_to_interpolate_temperature=''

# The below variables (y/n) are various options dependent on developer’s preference
export freshcompile='' # Would you like a fresh compilation of the executables?
export usecleanup=''    # Clears up space in work dir after tracker is ran to completion; does not effect any files that the tracker creates

# -------------------------------------------------------------------------------------------------
# ADDITIONAL VARIABLE DECLARINING, DOES NOT NEED TO BE EDITED BY USER

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
export today=$(date +"%a-%b%d")

# set wdir path
export wdir=${workdir}/${today}
if [ ! -d ${wdir} ]; then mkdir -p ${wdir}; fi

set +x
# -------------------------------------------------------------------------------------------------
# INVOKE SCRIPTS

# compile source code
export compile=${rundir}/subscripts/compile_grib.sh

cd ${codedir}
if [ ${freshcompile} = 'n' ]; then
  # check to make sure there is an exec directory and that it isn't empty
  if [ -n "$(ls -A ${execdir})" ] || [ ! -d ${execdir} ]; then
    echo "no exec directory exists or is empty; forcing compilation"
    source ${compile}
  else # exec dir exsists and is not empty 
    echo "Skipping compilation"
  fi
else # fresh compilation
  source ${compile}
fi
cd ${rundir}

# export & run variables code
export env_vars=${rundir}/subscripts/grib_env_vars.sh
source ${env_vars}

# export & run tcvitals script; this will either produce tcvitals file or use developer's tcvitals file
export tcvitals=${rundir}/subscripts/tcvitals_grib.sh
source ${tcvitals}

# export & run input data scripts; the file that is called is dependent on the value of 'file_sequence'
if [ ${file_sequence} = "onebig" ]; then
  export onebigscript=${rundir}/subscripts/onebig_grib.sh
  source ${onebigscript}
else  # file_sequence = "multi"
  export multiscript=${rundir}/subscripts/multi_grib.sh
  source ${multiscript}
fi

# export & run populate namelist script
export populatenamelist=${rundir}/subscripts/namelist_grib.sh
source ${populatenamelist}

# export & run input/output files script
export ioscript=${rundir}/subscripts/IOfiles_grib.sh
source ${ioscript}

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

# -------------------------------------------------------------------------------------------------
# RUN CLEAN UP SCRIPT
export runcleanup=${rundir}/subscripts/cleanup_grib.sh
if [ ${usecleanup} = 'y' ]; then
  source ${runcleanup}
fi