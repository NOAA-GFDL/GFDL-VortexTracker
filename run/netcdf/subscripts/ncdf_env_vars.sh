# -------------------------------------------------------------------------------------------------
# SET UP ENVIRONMENT VARIABLES
set -x

export inp_data_type='netcdf'
export file_sequence='onebig'

# get netcdf time units
cp ${datadir}/${ncdf_filename} ${wdir}/.
cd ${wdir}

ncdf_time_units="$(ncdump -h ${ncdf_filename} | grep "time:units" | awk -F= '{print $2}' | awk -F\" '{print $2}' | awk '{print $1}')"
export ${ncdf_time_units}
export lead_time_units=${ncdf_time_units}
echo "NetCDF time units pulled from data file = ${ncdf_time_units}"

# ---------- needed for both data types ----------

export atcfnum=15
export atcffreq=600
export atcfymdh=${pdy}${hh}

# ----- floating point values that don't typically change -----

# grid boundaries
export trkrebd=339.0
export trkrwbd=260.0
export trkrnbd=40.0
export trkrsbd=7.0

# parameters used for tracker
export max_mslp_850=400.0
export mslpthresh=0.0015
export v850thresh=1.5000
export v850_qwc_thresh=1.0000
export cint_grid_bound_check=0.50
export wcore_depth=1.0
export contour_interval=1.0
export radii_pctile=95.0
export radii_free_pass_pctile=67.0
export radii_width_thresh=15.0
export depth_of_mslp_for_gen_scan=1.0

# yes/no variables
export phaseflag='y'
export structflag='y'
export ikeflag='y'
export genflag='y'
export sstflag='y'
export shear_calc_flag='y'
export gen_read_rh_fields='n'
export need_to_compute_rh_from_q='y'
if [ ${use_land_mask} = 'n' ]; then
  export smoothe_mslp_for_gen_scan='y'
else    # use_land_mask = 'y'
  export smoothe_mslp_for_gen_scan='n'
fi
export write_vit='n'
export use_backup_mslp_grad_check='y'
export use_backup_850_vt_check='y'
export want_oci=.true.                    # (.true. or .false.)

# user wants to track variables
export user_wants_to_track_zeta850='y'
export user_wants_to_track_zeta700='y'
export user_wants_to_track_wcirc850='y' 
export user_wants_to_track_wcirc700='y'
export user_wants_to_track_gph850='y'
export user_wants_to_track_gph700='y'
export user_wants_to_track_mslp='y'
export user_wants_to_track_wcircsfc='y'
export user_wants_to_track_zetasfc='y'
export user_wants_to_track_thick500850='n'
export user_wants_to_track_thick200500='n'
export user_wants_to_track_thick200850='n'

# char value variables
export phase_scheme='both'    # 'both', 'vtt', or 'cps'
export basin='al'

# ----- grib specific vars -----

# The following variables have to be set to a value here to avoid breaking code when the namelist is declared
export gribver=1
export g1_mslp_parm_id=130
export g1_sfcwind_lev_typ=105
export g1_sfcwind_lev_val=10
export g2_jpdtn=0               # 0 for deterministic data; 1 for ens data
export g2_mslp_parm_id=192
export model=41

# -------------------------------------------------------------------------------------------------
set +x