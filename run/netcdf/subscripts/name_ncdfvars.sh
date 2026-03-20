# -------------------------------------------------------------------------------------------------
# DEFINE NETCDF VARIABLE DEFINITIONS
set -x

# The variables declared below are common meteorlogical variables that the source code uses to
# produce the cyclone(s) path. Please carefully go through your data file to match the variables
# listed below with the correct name they are recorded with in your file.
# All of the variables are defaulted to = 'X' because netcdf files vary with naming conventions.
# If your file does not include the variable, for example, temperature at 600mb (ncdf_temp600name)
# leave that set to = 'X'

export ncdf_num_netcdf_vars=999
export ncdf_time_name=''             # time (hours, mins, etc.)
export ncdf_lon_name=''              # longitude (degrees_east)
export ncdf_lat_name=''              # latitude (degrees_north)
export ncdf_sstname=''               # sea surface temperature (K)
export ncdf_mslpname=''              # mean sea level pressure (mb)
export ncdf_usfcname=''              # u-wind at 10m (m/s)
export ncdf_vsfcname=''              # v-wind at 10m (m/s)
export ncdf_u850name=''              # 850mb u-wind/x-wind component (m/s)
export ncdf_u700name=''              # 700mb u-wind/x-wind component (m/s)
export ncdf_u500name=''              # 500mb u-wind/x-wind component (m/s)
export ncdf_u200name=''              # 200mb u-wind/x-wind component (m/s)
export ncdf_v850name=''              # 850mb v-wind/y-wind component (m/s)
export ncdf_v700name=''              # 700mb v-wind/y-wind component (m/s)
export ncdf_v500name=''              # 500mb v-wind/y-wind component (m/s)
export ncdf_v200name=''              # 200mb v-wind/y-wind component (m/s)
export ncdf_z900name=''              # 900mb geopotential height (m)
export ncdf_z850name=''              # 850mb geopotential height (m)
export ncdf_z800name=''              # 800mb geopotential height (m)
export ncdf_z750name=''              # 750mb geopotential height (m)
export ncdf_z700name=''              # 700mb geopotential height (m)
export ncdf_z650name=''              # 650mb geopotential height (m)
export ncdf_z600name=''              # 600mb geopotential height (m)
export ncdf_z550name=''              # 550mb geopotential height (m)
export ncdf_z500name=''              # 500mb geopotential height (m)
export ncdf_z450name=''              # 450mb geopotential height (m)
export ncdf_z400name=''              # 400mb geopotential height (m)
export ncdf_z350name=''              # 350mb geopotential height (m)
export ncdf_z300name=''              # 300mb geopotential height (m)
export ncdf_z200name=''              # 200mb geopotential height (m)
export ncdf_temp1000name=''          # 1000mb temperature (K)
export ncdf_temp925name=''           # 925mb temperature (K)
export ncdf_temp800name=''           # 800mb temperature (K)
export ncdf_temp750name=''           # 750mb temperature (K)
export ncdf_temp700name=''           # 500mb temperature (K)
export ncdf_temp650name=''           # 650mb temperature (K)
export ncdf_temp600name=''           # 600mb temperature (K)
export ncdf_tmean_300_500_name=''    # averaged 300mb-500mb temperature (K)
export ncdf_spfh1000name=''          # 1000mb specific humidity (kg/kg)
export ncdf_spfh925name=''           # 925mb specific humidity (kg/kg)
export ncdf_q850name=''              # 850mb specific humidity (kg/kg)
export ncdf_spfh800name=''           # 800mb specific humidity (kg/kg)
export ncdf_spfh750name=''           # 750mb specific humidity (kg/kg)
export ncdf_spfh700name=''           # 700mb specific humidity (kg/kg)
export ncdf_spfh650name=''           # 650mb specific humidity (kg/kg)
export ncdf_spfh600name=''           # 600mb specific humidity (kg/kg)
export ncdf_rh1000name=''            # 1000mb relative humidity (%)
export ncdf_rh925name=''             # 925mb relative humidity (%)
export ncdf_rh800name=''             # 800mb relative humidity (%)
export ncdf_rh750name=''             # 750mb relative humidity (%)
export ncdf_rh700name=''             # 700mb relative humidity (%)
export ncdf_rh650name=''             # 650mb relative humidity (%)
export ncdf_rh600name=''             # 600mb relative humidity (%)
export ncdf_omega500name=''          # 500mb vertical velocity (Pa/s)
export ncdf_rv850name=''             # 850mb relative vorticity (s-1)
export ncdf_rv700name=''             # 700mb relative vorticity (s-1)
export ncdf_lmaskname=''             # land mask variable name (N/A)

# -------------------------------------------------------------------------------------------------
set +x