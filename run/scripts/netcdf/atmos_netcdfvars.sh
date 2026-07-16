# -------------------------------------------------------------------------------------------------
# DEFINE NETCDF VARIABLE DEFINITIONS
set -x

# When you are finished declaring the variables, please modify usercheck to = 'CHECKED'
# IMPORTANT: if this variable is not edited, the ncdf run script will intentionally break
export usercheck='NOTCHECKED'

# The variables declared below are common meteorlogical variables that the source code uses to
# produce the cyclone(s) path. Please carefully go through your data file to match the variables
# listed below with the correct name they are recorded with in your file.
# All of the variables are defaulted to = 'X' because netcdf files vary with naming conventions.
# If your file does not include the variable, for example, temperature at 600mb (ncdf_temp600name)
# leave that set to = 'X'

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
export ncdf_lmaskname='X'             # land mask variable name (N/A)

# -------------------------------------------------------------------------------------------------
set +x