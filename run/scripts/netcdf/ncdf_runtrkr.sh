#!/bin/bash

# -------------------------------------------------------------------------------------------------
# PLEASE READ COMMENTS CAREFULLY BEFORE EDITING THIS FILE
# For additional instructions, you can find the documentation here:

# ----- Model input data info -----

# Where the data files being stored
export datadir=

# What is the filename of the data
export ncdf_filename=''

# Initialization forecast date/time matching your data (yyyymmddhh format)
export initymdh=

# ATCF name of model (4 char long)
export atcfname=''

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
export use_land_mask='n'
export read_separate_land_mask_file='n'
# Add path to landmask file below if 'y' to above variables, leave blank if 'n'
export ncdf_ls_mask_filename=''

# If developer would like to include vortex tilt diagnostics;
# 'vortex_tilt_flag' = 'y'/'n'
# 'vortex_tilt_parm' = '<tilt_parameter_name>'
# 'vortex_tilt_allow_thresh' = float
export vortex_tilt_flag=''
export vortex_tilt_parm=''
export vortex_tilt_allow_thresh=''
# -------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------
# DO NOT EDIT; the following code will save the information inputed and use it to run the tracker
export ncdfdir=${PWD}
export subdir=${PWD%/*/*}/subscripts
export vitalsdir=${subdir}/archived_vitals
export userinputs=${PWD%/*/*}/work/tmpfiles/userinputs.txt
export inp_data_type='netcdf'

cat << EOF > ${userinputs}
datadir='${datadir}'
ncdf_filename='${ncdf_filename}'
initymdh='${initymdh}'
atcfname='${atcfname}'
tcvitals_file='${tcvitals_file}'
trkrtype='${trkrtype}'
modtyp='${modtyp}'
nest_type='${nest_type}'
use_land_mask='${use_land_mask}'
read_separate_land_mask_file='${read_separate_land_mask_file}'
ncdf_ls_mask_filename='${ncdf_ls_mask_filename}'
vortex_tilt_flag='${vortex_tilt_flag}'
vortex_tilt_parm='${vortex_tilt_parm}'
vortex_tilt_allow_thresh='${vortex_tilt_allow_thresh}'
ncdfdir='${ncdfdir}'
subdir='${subdir}'
vitalsdir='${vitalsdir}'
datatype='${inp_data_type}'
EOF

export start_trkr=${subdir}/inittrkr.sh
source ${start_trkr}
# -------------------------------------------------------------------------------------------------