#!/bin/bash


# print line numbers in std out
export PS4=' line $LINENO: '
set -x
# -------------------------------------------------------------------------------------------------
# PLEASE READ COMMENTS CAREFULLY BEFORE EDITING THIS FILE
# For additional instructions, you can find the documentation here:

# ----- Model input data info -----

# Where the data files being stored
export datadir=

# Initialization forecast date/time matching your data (yyyymmddhh format)
export initymdh=

# Add the respective forcast hours to match your data; (spaces between hrs only, no commas)
# This will be used for temperature and height interpolation
export fcsthrs=''

# gribver=1 for GRIB1 data; gribver=2 for GRIB2 data
export gribver=

# file_sequence='multi' when there are multiple files with single frcast hour;
# file_sequenxe='onebig' when all of the data is in one single file
export file_sequence=''

# ATCF name of model (4 char long)
export atcfname=''
# (Optional) This is descriptive and up to the developer (e.g., "6thdeg", "9km_run","1.6km_run", "15km_ens_run_member_n13", etc)
export rundescr=''
# (Optional) If used, it should be something that identifies the particular storm, preferably using the atcf ID.
# For example, the GFDL model standard is to use something like "ike09l", or "two02e", etc. 
export atcfdescr=''

# ----- Additional Info -----

# If you already have a tcvitals file, add path and name below.
# If the file has not been created yet, leave this blank and the make_tcvitals.sh script will create one
# Please note, our archived vitals information contains data up until 12/18/2025
export tcvitals_file=

# trkrtype=tracker for known storms, trkrtype=tcgen for genesis runs
export trkrtype=''

# Variables to declare the model's grid and nesting configurations
export modtyp=''         # 'global' or 'regional'
export nest_type=''      # 'moveable' or 'fixed'

# Set 'use_land_mask' = 'y' AND 'read_serperate_land_mask_file' = 'y' if landmask file is needed.
export use_land_mask=''
export read_separate_land_mask_file=''
export ls_mask_filename=''

# If developer would like to include vortex tilt diagnostics;
# 'vortex_tilt_flag' = 'y'/'n'
# 'vortex_tilt_parm' = '<tilt_parameter_name>'
# 'vortex_tilt_allow_thresh' = float
export vortex_tilt_flag=''
export vortex_tilt_parm=''
export vortex_tilt_allow_thresh=

# 'need_to_*' = 'y'/'n'
# These variables are used to detemerine if input data needs to be interpolated; i.e. input files being used
# to run the tracker don't have data at 50mb height level (850, 750, 550, etc.).
# If 'need_to_use_vint_or_tave' set to 'y' then interpolation code will be ran within the multi or onebig scripts.
# User can determine if only height and/or temperature interpolation is calculated determined by the value of the following variables
export need_to_use_vint_or_tave=''
export need_to_interpolate_height=''
export need_to_interpolate_temperature=''
# -------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------
# DO NOT EDIT; the following code will save the information inputed and use it to run the tracker

export gribdir=${PWD}
export initdatadir=${PWD%/*/*}/init_data
export subdir=${PWD%/*/*}/subscripts
export vitalsdir=${subdir}/archived_vitals
export userinputs=${PWD%/*/*}/work/tmpfiles/userinputs.txt
export inp_data_type='grib'

cat << EOF > ${userinputs}
datadir='${datadir}'
initymdh='${initymdh}'
fcsthrs='${fcsthrs}'
gribver='${gribver}'
file_sequence='${file_sequence}'
atcfname='${atcfname}'
rundescr='${rundescr}'
atcfdescr='${atcfdescr}'
tcvitals_file='${tcvitals_file}'
trkrtype='${trkrtype}'
modtyp='${modtyp}'
nest_type='${nest_type}'
vortex_tilt_flag='${vortex_tilt_flag}'
vortex_tilt_parm='${vortex_tilt_parm}'
vortex_tilt_allow_thresh='${vortex_tilt_allow_thresh}'
need_to_use_vint_or_tave='${need_to_use_vint_or_tave}'
need_to_interpolate_height='${need_to_interpolate_height}'
need_to_interpolate_temperature='${need_to_interpolate_temperature}'
vitalsdir='${vitalsdir}'
gribdir='${gribdir}'
initdatadir='${initdatadir}'
subdir='${subdir}'
datatype='${inp_data_type}'
EOF

export start_trkr=${subdir}/runtrkr.sh
source ${start_trkr}
set +x
# -------------------------------------------------------------------------------------------------