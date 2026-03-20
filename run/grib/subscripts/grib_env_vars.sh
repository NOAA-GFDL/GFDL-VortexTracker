# -------------------------------------------------------------------------------------------------
# SET UP ENVIRONMENT VARIABLES
set -x

# grib specific
export inp_data_type='grib'
export lead_time_units='hours'

export g1_mslp_parm_id=130
export g1_sfcwind_lev_typ=105
export g1_sfcwind_lev_val=10

export g2_jpdtn=0               # 0 for deterministic data; 1 for ens data
export g2_mslp_parm_id=192

export model=1

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
export smoothe_mslp_for_gen_scan='y'
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

# ----- netcdf specific vars -----

# The following variables have to be set to a value here to avoid breaking code when the namelist is declared

export ncdf_ls_mask_filename='n'
export read_separate_land_mask_file='n'
export use_land_mask='n'

# -------------------------------------------------------------------------------------------------
# DEFINE NETCDF VARIABLE DEFINITIONS

export ncdf_num_netcdf_vars=999
export ncdf_time_name='X'             # time (hours, mins, etc.)
export ncdf_lon_name='X'              # longitude (degrees_east)
export ncdf_lat_name='X'              # latitude (degrees_north)
export ncdf_sstname='X'               # sea surface temperature (K)
export ncdf_mslpname='X'              # mean sea level pressure (mb)
export ncdf_usfcname='X'              # u-wind at 10m (m/s)
export ncdf_vsfcname='X'              # v-wind at 10m (m/s)
export ncdf_u850name='X'              # 850mb u-wind/x-wind component (m/s)
export ncdf_u700name='X'              # 700mb u-wind/x-wind component (m/s)
export ncdf_u500name='X'              # 500mb u-wind/x-wind component (m/s)
export ncdf_u200name='X'              # 200mb u-wind/x-wind component (m/s)
export ncdf_v850name='X'              # 850mb v-wind/y-wind component (m/s)
export ncdf_v700name='X'              # 700mb v-wind/y-wind component (m/s)
export ncdf_v500name='X'              # 500mb v-wind/y-wind component (m/s)
export ncdf_v200name='X'              # 200mb v-wind/y-wind component (m/s)
export ncdf_z900name='X'              # 900mb geopotential height (m)
export ncdf_z850name='X'              # 850mb geopotential height (m)
export ncdf_z800name='X'              # 800mb geopotential height (m)
export ncdf_z750name='X'              # 750mb geopotential height (m)
export ncdf_z700name='X'              # 700mb geopotential height (m)
export ncdf_z650name='X'              # 650mb geopotential height (m)
export ncdf_z600name='X'              # 600mb geopotential height (m)
export ncdf_z550name='X'              # 550mb geopotential height (m)
export ncdf_z500name='X'              # 500mb geopotential height (m)
export ncdf_z450name='X'              # 450mb geopotential height (m)
export ncdf_z400name='X'              # 400mb geopotential height (m)
export ncdf_z350name='X'              # 350mb geopotential height (m)
export ncdf_z300name='X'              # 300mb geopotential height (m)
export ncdf_z200name='X'              # 200mb geopotential height (m)
export ncdf_temp1000name='X'          # 1000mb temperature (K)
export ncdf_temp925name='X'           # 925mb temperature (K)
export ncdf_temp800name='X'           # 800mb temperature (K)
export ncdf_temp750name='X'           # 750mb temperature (K)
export ncdf_temp700name='X'           # 500mb temperature (K)
export ncdf_temp650name='X'           # 650mb temperature (K)
export ncdf_temp600name='X'           # 600mb temperature (K)
export ncdf_tmean_300_500_name='X'    # averaged 300mb-500mb temperature (K)
export ncdf_spfh1000name='X'          # 1000mb specific humidity (kg/kg)
export ncdf_spfh925name='X'           # 925mb specific humidity (kg/kg)
export ncdf_q850name='X'              # 850mb specific humidity (kg/kg)
export ncdf_spfh800name='X'           # 800mb specific humidity (kg/kg)
export ncdf_spfh750name='X'           # 750mb specific humidity (kg/kg)
export ncdf_spfh700name='X'           # 700mb specific humidity (kg/kg)
export ncdf_spfh650name='X'           # 650mb specific humidity (kg/kg)
export ncdf_spfh600name='X'           # 600mb specific humidity (kg/kg)
export ncdf_rh1000name='X'            # 1000mb relative humidity (%)
export ncdf_rh925name='X'             # 925mb relative humidity (%)
export ncdf_rh800name='X'             # 800mb relative humidity (%)
export ncdf_rh750name='X'             # 750mb relative humidity (%)
export ncdf_rh700name='X'             # 700mb relative humidity (%)
export ncdf_rh650name='X'             # 650mb relative humidity (%)
export ncdf_rh600name='X'             # 600mb relative humidity (%)
export ncdf_omega500name='X'          # 500mb vertical velocity (Pa/s)
export ncdf_rv850name='X'             # 850mb relative vorticity (s-1)
export ncdf_rv700name='X'             # 700mb relative vorticity (s-1)
export ncdf_lmaskname='X'             # land mask variable name(N/A)

# -------------------------------------------------------------------------------------------------
set +x