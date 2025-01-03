      module def_vitals
        type tcvcard         ! Define a new type for a TC Vitals card
          character*4   tcv_center      ! Hurricane Center Acronym
          character*4   tcv_storm_id    ! Storm Identifier (03L, etc)
          character*9   tcv_storm_name  ! Storm name
          integer       tcv_ymd         ! Date of observation (yyyymmdd)
          integer       tcv_hhmm        ! Time of observation (UTC)
          integer       tcv_lat         ! Storm Lat (*10), always >0
          character*1   tcv_latns       ! 'N' or 'S'
          integer       tcv_lon         ! Storm Lon (*10), always >0
          character*1   tcv_lonew       ! 'E' or 'W'
          integer       tcv_stdir       ! Storm motion vector (in degr)
          integer       tcv_stspd       ! Spd of storm movement (m/s*10)
          integer       tcv_pcen        ! Min central pressure (mb)
          integer       tcv_penv        ! val outrmost closed isobar(mb)
          integer       tcv_penvrad     ! rad outrmost closed isobar(km)
          integer       tcv_vmax        ! max sfc wind speed (m/s)
          integer       tcv_vmaxrad     ! rad of max sfc wind spd (km)
          integer       tcv_r15ne       ! NE rad of 15 m/s winds (km)
          integer       tcv_r15se       ! SE rad of 15 m/s winds (km)
          integer       tcv_r15sw       ! SW rad of 15 m/s winds (km)
          integer       tcv_r15nw       ! NW rad of 15 m/s winds (km)
          character*1   tcv_depth       ! Storm depth (S,M,D) X=missing
        end type tcvcard
        type (tcvcard), save, allocatable :: storm(:)
        integer, save, allocatable :: stormswitch(:)
        real, save, allocatable    :: slonfg(:,:),slatfg(:,:)
        character*3, save, allocatable :: stcvtype(:) ! FOF or TCV
      end module def_vitals
c
      module gen_vitals
        type gencard     ! Define a new type for a genesis vitals card
          integer       gv_gen_date    ! genesis date in yyyymmddhh
          integer       gv_gen_fhr     ! genesis fcst hour (usually 0)
          integer       gv_gen_lat     ! genesis lat (*10), always >0
          character*1   gv_gen_latns   ! 'N' or 'S'
          integer       gv_gen_lon     ! genesis lon (*10), always >0
          character*1   gv_gen_lonew   ! 'W' or 'E'
          character*3   gv_gen_type    ! 'FOF'; or TC Vitals ATCF ID
          integer       gv_obs_ymd     ! Date of observation (yyyymmdd)
          integer       gv_obs_hhmm    ! Time of observation (UTC)
          integer       gv_obs_lat     ! Storm Lat (*10), always >0
          character*1   gv_obs_latns   ! 'N' or 'S'
          integer       gv_obs_lon     ! Storm Lon (*10), always >0
          character*1   gv_obs_lonew   ! 'E' or 'W'
          integer       gv_stdir       ! Storm motion vector (in degr)
          integer       gv_stspd       ! Spd of storm movement (m/s*10)
          integer       gv_pcen        ! Min central pressure (mb)
          integer       gv_penv        ! val outrmost closed isobar(mb)
          integer       gv_penvrad     ! rad outrmost closed isobar(km)
          integer       gv_vmax        ! max sfc wind speed (m/s)
          integer       gv_vmaxrad     ! rad of max sfc wind spd (km)
          integer       gv_r15ne       ! NE rad of 15 m/s winds (km)
          integer       gv_r15se       ! SE rad of 15 m/s winds (km)
          integer       gv_r15sw       ! SW rad of 15 m/s winds (km)
          integer       gv_r15nw       ! NW rad of 15 m/s winds (km)
          character*1   gv_depth       ! Storm depth (S,M,D) X=missing
        end type gencard
        type (gencard), save, allocatable :: gstorm(:)
      end module gen_vitals
c
      module inparms
        type datecard  ! Define a new type for the input namelist parms
          integer       bcc    ! First 2 chars of yy of date (century)
          integer       byy    ! Beginning yy of date to search for 
          integer       bmm    ! Beginning mm of date to search for 
          integer       bdd    ! Beginning dd of date to search for 
          integer       bhh    ! Beginning hh of date to search for 
          integer       model  ! integer identifier for model data used
          character*8   modtyp ! 'global' or 'regional'
          character*7   lt_units ! 'hours' or 'minutes' to indicate the
                                 ! units of lead times in grib files
          character*6   file_seq ! 'onebig' or 'multi' tells if grib
                                 ! data will be input as one big file or
                                 ! as individual files for each tau.
          character*8   nesttyp ! Either "moveable" or "fixed"
        end type datecard
      end module inparms
c
      module trkrparms
        type trackstuff  ! Define a new type for various tracker parms
          real          westbd  ! Western boundary of search area
          real          eastbd  ! Eastern boundary of search area
          real          northbd ! Northern boundary of search area
          real          southbd ! Southern boundary of search area
          character*7   type    ! 'tracker', 'midlat' or 'tcgen'
          real          mslpthresh ! min mslp gradient to be maintained
          character*1   use_backup_mslp_grad_check ! If a mslp fix could
                                 ! not be made, do you still want
                                 ! to do an mslp gradient check, but 
                                 ! surrounding the multi-parm fix 
                                 ! position (since we don't have an 
                                 ! mslp fix position to search around).
                                 ! Has a value of 'y' or 'n'.
          real          max_mslp_850 ! Max allowable distance between 
                                 ! the tracker-found center fixes for 
                                 ! mslp and 850 zeta.
          real          v850thresh ! minimum azimuthally-averaged 850 Vt
                                 ! to be maintained
          real          v850_qwc_thresh ! min avg 850 Vt that must be
                                 ! maintained in *each* quadrant for the
                                 ! quadrant wind check routine that is
                                 ! done for storms close to the lateral
                                 ! boundary of fixed, regional grids.
          character*1   use_backup_850_vt_check ! If an 850 mb wcirc fix
                                 ! could not be made, do you still want
                                 ! to do an 850 mb Vt wind check, but 
                                 ! surrounding the multi-parm fix 
                                 ! position (since we don't have an 850
                                 ! wcirc fix position to search around).
                                 ! Has a value of 'y' or 'n'.
          character*8   gridtype ! 'global' or 'regional'
          real          contint  ! MSLP contour interval to be used for 
                                 ! "midlat" or "tcgen" cases.     
          logical       want_oci ! Flag for whether to compute & write
                                 ! out roci for a trkrtype=tracker run
          character*1   out_vit  ! Flag for whether to write out vitals
          character*1   use_land_mask ! Flag used only in tcgen tracking
                                 ! that tells whether or not to use a 
                                 ! land-sea mask to disregard candidate
                                 ! lows that are over land.  It does not
                                 ! filter out storms that have already 
                                 ! formed at a previous time and then 
                                 ! move over land... it only filters 
                                 ! out for potential new candidate lows.
                                 ! Has a value of 'y' or 'n'.
          character*1   read_separate_land_mask_file ! Flag that says 
                                 ! whether or not a separate file will
                                 ! be read in that contains the land-
                                 ! sea mask.  Has a value of 'y' or 'n'.
          character*6   inp_data_type ! Has a value of 'grib' or 
                                      ! 'netcdf'
          integer       gribver  ! Indicates whether input data is 
                                 ! GRIBv1 or GRIBv2 (value of '1' 
                                 ! or '2')
          integer       g2_jpdtn ! Indicates GRIB2 template to use when
                                 ! reading (0 = deterministic fcst, 
                                 ! 1 = ens fcst)
          integer       g2_mslp_parm_id ! This is the GRIB2 ID code for
                                 ! MSLP.  For most models, it is set to
                                 ! 1 (which is simply described as 
                                 ! "Pressure Reduced to MSL").  However,
                                 ! note that for GFS and GDAS, they 
                                 ! include an additional MSLP record
                                 ! that uses a different SLP reduction
                                 ! method that often shows lower 
                                 ! pressures for cyclone centers.
                                 !   1 = standard MSLP reduction
                                 ! 192 = GFS / Eta model reduction
          integer       g1_mslp_parm_id ! This is the GRIB1 ID code for
                                 ! MSLP.  For most models, it is set to
                                 ! 102 (which is simply described as 
                                 ! "Pressure Reduced to MSL").  However,
                                 ! note that for GFS and GDAS, they 
                                 ! include an additional MSLP record
                                 ! that uses a different SLP reduction
                                 ! method that often shows lower 
                                 ! pressures for cyclone centers.
                                 ! 102 = standard MSLP reduction
                                 ! 130 = GFS / Eta model reduction
          integer       g1_sfcwind_lev_typ ! This is the GRIB1 level
                                 ! code for near-sfc winds.  At this
                                 ! time (2016), almost all models are
                                 ! reporting 10m winds here, but at 
                                 ! least for GRIB1, there are some 
                                 ! differences in how various Centers
                                 ! code that.  Most use a level type
                                 ! (PDS Octet 10) of 105 and then an 
                                 ! actual value of the level in PDS
                                 ! Octets 11 & 12 as 10 (for 10m).
                                 ! However, for some reason, ECMWF
                                 ! uses a level type of 1 (which is
                                 ! supposed to be for ground surface),
                                 ! and ECMWF's actual value of the 
                                 ! level is listed as 0 (UKMET does
                                 ! the same thing as ECMWF)
                                 ! Use 105 for most models
                                 ! Use 1 for ECMWF, UKMET,...others?
          integer       g1_sfcwind_lev_val ! This is the GRIB1 code for
                                 ! the actual value of the level of the
                                 ! near-sfc winds.  As above, most 
                                 ! Centers list it as 10, but some list
                                 ! it as 0.
                                 ! Use 10 for most models
                                 ! Use  1 for ECMWF, UKMET,...others?
          integer       enable_timing  ! 0=disable timing
        end type trackstuff
      end module trkrparms
c
      module contours
        integer, parameter :: maxconts=100 ! max # of cont. intervals
        real, save  :: contint_grid_bound_check  ! Contour interval to
                                 ! be used for MSLP for the fixed grid
                                 ! boundary check that I implemented
                                 ! in Sep 2020.
        type cint_stuff  ! Define a new type for contour interval info
          real    :: xmaxcont ! max contour level in a field
          real    :: xmincont ! min contour level in a field
          real    :: contvals(maxconts) ! contour values in the field
          integer :: numcont  ! # of contour levels in a field
        end type cint_stuff
      end module contours
c     
      module atcf
        integer         atcfnum   ! ATCF ID of model (63 for GFDL...)
        character*4     atcfname  ! ATCF Name of model (GFSO for GFS...)
        integer         atcfymdh  ! YMDH to be used as initial date for
                                  ! output ATCF forecast records.  Will
                                  ! be equal to initial run date for all
                                  ! models except SREF; SREF will have a
                                  ! start date artificially modified to
                                  ! be 3 hours earlier in order to not
                                  ! cause the NHC interpolator to burp.
        integer         atcffreq  ! frequency (in centahours) of output
                                  ! for atcfunix and certain other
                                  ! files.  Default: 600 (six-hourly)
      end module atcf
c
      module gfilename_info
        character*4 ,save :: gmodname  ! Model ID for first part of GRIB
                                  ! file name ("gfdl","hwrf","hrs", etc)
        character*40 ,save :: rundescr ! This is descriptive and up to
                                  ! the developer (e.g., "6thdeg",
                                  ! "9km_run","1.6km_run"         
                                  ! "15km_ens_run_member_n13", etc)
        character*40 ,save :: atcfdescr ! This is optional.  If used, it
                                  ! should be something that identifies
                                  ! the particular storm, preferably
                                  ! using the atcf ID.  For example, the
                                  ! GFDL model standard is to use
                                  ! something like "ike09l", or  
                                  ! "two02e", etc.             
      end module gfilename_info
c
      module phase
        character*1 , save ::   phaseflag   ! Will phase be determined
                                            ! (y/n)                   
        character*4 , save ::   phasescheme ! What scheme to use:
                                    ! cps  = Hart's cyclone phase space
                                    ! vtt  = Vitart                    
                                    ! both = Both cps and vtt are used
        real, save  :: wcore_depth  ! The contour interval (in deg K)
                             ! used in determining if a closed contour 
                             ! exists in the 300-500 mb T data, for
                             ! use with the vtt scheme.
      end module phase
c
      module structure
        character*1 , save ::   structflag  ! Will structure be
                                            ! analyzed (y/n)?
        character*1 , save ::   ikeflag     ! Will IKE & SDP be
                                            ! computed (y/n)?
        real, save :: radii_pctile  ! The percentile that is used in
                             ! the new (2022) wind radii scheme for
                             ! determining the representative wind
                             ! value within each quadrant radial band.
        real, save :: radii_free_pass_pctile  ! If the percentile value
                             ! of R34 in this band is at least this 
                             ! great, then bypass all further checking
                             ! and consider the R34 value to be at this
                             ! radius.  You should make this something
                             ! substantial, i.e., not just 95.0, but 
                             ! something like 67.0, meaning at least 
                             ! 1/3 of points in this band must > 34 kts
                             ! in order to "get the free pass".
        real, save :: radii_width_thresh ! The width (in km) that is
                             ! used in the new (2022) wind radii scheme
                             ! for checking how wide -- or how robust --
                             ! an R34 value is.
      end module structure
c
      module shear_diags
        character*1 , save ::   shearflag   ! Will vertical shear
                                            ! be analyzed (y/n)?
      end module shear_diags
c
      module sst_diags
        character*1 , save ::   sstflag     ! Will SST 
                                            ! be analyzed (y/n)?
      end module sst_diags
c
      module genesis_diags
        character*1 , save ::   genflag        ! Will genesis diags
                                               ! be analyzed and
                                               ! reported (y/n)?
        character*1 , save ::   gen_read_rh_fields ! Will RH fields be
                                               ! read in directly (y/n)?
        character*1 , save ::   need_to_compute_rh_from_q ! Will spec.
                                               ! humidity (q) fields be
                                               ! read in to compute RH
                                               ! if RH is not read in?
                                               ! (y/n)
        character*1 , save ::   smoothe_mslp_for_gen_scan ! Did 
                                               ! user request to smoothe
                                               ! the MSLP data before
                                               ! scanning for new storms
                                               ! in the forecast (y/n)?
        real , save :: depth_of_mslp_for_gen_scan ! Depth of the
                                     ! MSLP field (in mb) that is used
                                     ! by the initial scan for new
                                     ! storms in subroutine
                                     ! check_mslp_radial_gradient
      end module genesis_diags
c
      module vortex_tilt_diags
        character*1, save ::   vortex_tilt_flag ! Will vortex tilt diags
                                                ! be analyzed and
                                                ! reported (y/n)?
        character*5, save ::   vortex_tilt_parm ! Can be either zeta,
                                                ! wcirc, hgt, or temp.
        integer, parameter ::  vortex_max_levs=100 ! Max allowable
                                                ! number of vertical
                                                ! levs for vortex tilt
        integer, save :: vortex_tilt_allow_thresh ! Max distance (km)
                                                ! per mb of height 
                                                ! difference allowed
                                                ! between vortex fixes
                                                ! at adjacent levels.
      end module vortex_tilt_diags
c     
      module tracked_parms
          real, save, allocatable  ::  zeta(:,:,:)
          real, save, allocatable  ::  u(:,:,:)
          real, save, allocatable  ::  v(:,:,:)
          real, save, allocatable  ::  hgt(:,:,:)
          real, save, allocatable  ::  slp(:,:)
          real, save, allocatable  ::  tmean(:,:)
          real, save, allocatable  ::  cpshgt(:,:,:)
          real, save, allocatable  ::  thick(:,:,:)
          real, save, allocatable  ::  lsmask(:,:)
          real, save, allocatable  ::  sst(:,:)
          real, save, allocatable  ::  q850(:,:)
          real, save, allocatable  ::  rh(:,:,:)
          real, save, allocatable  ::  spfh(:,:,:)
          real, save, allocatable  ::  temperature(:,:,:)
          real, save, allocatable  ::  omega500(:,:)
          real, save, allocatable  ::  wcirc_grid(:,:,:)
          real, save, allocatable  ::  utilt(:,:,:)
          real, save, allocatable  ::  vtilt(:,:,:)
          real, save, allocatable  ::  xtilt(:,:,:)
          real, save, allocatable  ::  xtiltlon(:,:)
          real, save, allocatable  ::  xtiltlat(:,:)
          real, save, allocatable  ::  xtiltval(:,:)
          real, save, allocatable  ::  xtilt_dist_flag(:,:)
          integer, save, allocatable :: ifhours(:)  
          integer, save, allocatable :: iftotalmins(:)
          integer, save, allocatable :: ifclockmins(:)
          integer, save, allocatable :: ltix(:)
          real, save, allocatable    :: fhreal(:)
          logical(1), save, allocatable :: utilt_readflag(:)
          logical(1), save, allocatable :: vtilt_readflag(:)
          logical(1), save, allocatable :: xtilt_readflag(:)
      end module tracked_parms
c
      module tracking_parm_prefs
        character*1, save :: user_wants_to_track_zeta850
        character*1, save :: user_wants_to_track_zeta700
        character*1, save :: user_wants_to_track_wcirc850
        character*1, save :: user_wants_to_track_wcirc700
        character*1, save :: user_wants_to_track_gph850
        character*1, save :: user_wants_to_track_gph700
        character*1, save :: user_wants_to_track_mslp
        character*1, save :: user_wants_to_track_wcircsfc
        character*1, save :: user_wants_to_track_zetasfc
        character*1, save :: user_wants_to_track_thick500850
        character*1, save :: user_wants_to_track_thick200500
        character*1, save :: user_wants_to_track_thick200850
      end module tracking_parm_prefs
c     
      module radii
c       For Barnes smoothing of parameters for tracking, e-folding
c       radius = retrk (km), influence radius = ritrk (km). Max radius
c       for searching for the max vorticity = rads (km).  There is an
c       important distinction between rads and ritrk.  rads is used to
c       determine the maximum distance from the guess position that
c       we'll allow points to be in order to be considered as a
c       candidate location for the updated fix position.  On the other
c       hand, ritrk is used once you're doing the barnes analysis on
c       data for that candidate location, so that if data is not within
c       distance ritrk of the candidate location, we ignore it.  Also, 
c       for use in find_maxmin, nhalf = the number of times to halve the
c       spacing of the search grid.  Note that different values are used
c       for the magnitude of the wind than for other parameters; this is
c       so that the search area is restricted in order to avoid a 
c       problem of the program finding one wind minimum near the center
c       and another one out near the storm's edge.
c
c       redlm and ridlm = the e-folding radius (km) and influence radius
c       (km) for Barnes analysis of u,v for updating first guess lat,lon
c       for search.  dlm = deep layer mean.
c
c        real, parameter :: retrk_most=60.0, retrk_vmag=60.0
c        real, parameter :: ritrk_most=120.0, ritrk_vmag=120.0
c        real, parameter :: rads_most=120.0, rads_vmag=120.0
c        real, parameter :: retrk_most=150.0, retrk_vmag=60.0
c        real, parameter :: ritrk_most=300.0, ritrk_vmag=120.0
c        real, parameter :: rads_most=300.0, rads_vmag=120.0
        real, parameter :: retrk_most=75.0, retrk_vmag=60.0
        real, parameter :: ritrk_most=150.0, ritrk_vmag=120.0
        real, parameter :: rads_most=300.0, rads_vmag=120.0
        real, parameter :: retrk_coarse=150.0, retrk_hres=60.0
        real, parameter :: rads_fine=200.0, rads_hres=150.0
        real, parameter :: ritrk_coarse=300.0, rads_coarse=350.0
        real, parameter :: rads_wind_circ=250.0
        real, parameter :: ri_wind_circ=150.0
c        real, parameter :: redlm=500.0, ridlm=2000.0
c        real, parameter :: redlm=500.0, ridlm=1700.0
        real, parameter :: redlm=500.0, ridlm=1000.0
        real, parameter :: re_genscan=50.0
        real, parameter :: ri_genscan=100.0
      end module radii
c
      module grid_bounds
        real, save ::  glatmin, glatmax, glonmin, glonmax  ! These 
                       ! define the boundaries of the input data grid
        real, save, allocatable ::  glat(:), glon(:)  ! Will be filled
                       ! with lat/lon values for each pt on input grid
      end module grid_bounds
c
      module error_parms
        real, parameter :: err_gfs_init=275.0 ! init errmax for gfs,mrf
                                              ! and gdas
        real, parameter :: err_reg_init=300.0 ! init errmax for others
        real, parameter :: err_ecm_max=330.0  ! errmax for ecmwf
        real, parameter :: err_reg_max=225.0  ! errmax for others for
                                              ! remaining fcst times
        real, parameter :: maxspeed_tc=60  ! max speed of storm movement
                                           ! for tracker or tcgen cases
        real, parameter :: maxspeed_ml=80  ! max speed of storm movement
                                           ! for midlat cases
C        real, parameter :: errpgro=1.25, errpmax=600.0
        real, parameter :: errpgro=1.25, errpmax=485.0
        real, parameter :: stermn = 0.1   ! Min Std dev for trk errors
        real, parameter :: uverrmax = 225.0  ! For use in get_uv_guess
      end module error_parms
c
      module set_max_parms
        integer, parameter :: maxstorm_tc=15  ! max # of storms pgm can
                                           ! handle, for tc tracker case
        integer, parameter :: maxstorm_mg=2000  ! max # of storms pgm can
                                      ! handle, for midlat or tcgen case
        integer, parameter :: maxtime=500  ! max # of fcst times pgm 
        integer, parameter :: maxtp=14     ! max # of tracked parms 
        integer, parameter :: maxmodel=20  ! max # of models currently 
                                           ! available
        integer, parameter :: max_ike_cats=6 ! max # of IKE categories
        integer, save :: interval_fhr      ! # of hrs between fcst times
        integer, parameter :: maxcenters=150 ! max # of max/min centers
                                             ! to be tracked.
      end module set_max_parms
c
      module level_parms
        integer, parameter :: nlevs=5   ! max # of vert levs to be read
                                        ! for u & v
        integer, parameter :: nlevg=3   ! # of vert levs to be used for
                                        ! figuring next guess position
        integer, parameter :: nlevhgt=4  ! # tracked levs for hgt
        integer, parameter :: nlevgrzeta=2  ! # tracked levs for
                                            ! gridded zeta values 
        integer, parameter :: nlevzeta=3 ! # tracked levs for zeta
        integer, parameter :: nlevthick=3 ! # tracked levs for thickness
        integer, parameter :: nlevmoist=7 ! # tracked levs for moisture
                                          ! & temp for genesis
                                          ! applications (q,rh,temp).
        integer, parameter :: levsfc=5  ! array position of sfc winds.
        integer, parameter :: nlev850=1 ! array position in u and v
        integer, parameter :: nlev700=2 ! arrays for 850, 700 & 500
        integer, parameter :: nlev500=3 ! winds.  Used in get_uv_center.
        integer, parameter :: nlev200=4 ! 200 mb winds are in array 
                                        ! position #4 as of 2021.
        real, save      :: wgts(nlevg)  ! Wghts for use in get_next_ges
        data wgts /0.25, 0.50, 0.25/    ! 850, 700 & 500 mb wgts
      end module level_parms
c
      module read_parms
        integer, parameter :: nreadparms=20 ! max # of parameters to
                                            ! read in for standard parms
        integer, parameter :: nreadcpsparms=13 ! max # of parameters to
                                            ! read in for Hart's CPS
        integer, parameter :: nreadgenparms=23 ! max # of parameters to
                                            ! read in for genesis parms
      end module read_parms
c
      module trig_vals
        real, save :: pi, dtr
        real, save :: dtk = 111.1949     ! Dist (km) over 1 deg lat
                                         ! using erad=6371.0e+3
        real, save :: erad = 6371.0e+3   ! Earth's radius (m)
        real, save :: ecircum = 40030.2  ! Earth's circumference
                                         ! (km) using erad=6371.e3
        real, save :: omega = 7.292e-5
      end module trig_vals
c
      module verbose_output
        integer, save :: verb        ! Level of detail printed 
                                     ! 0 = No output
                                     ! 1 = Error messages only
                                     ! 2 = 
                                     ! 3 = All      
        integer, save :: verb_g2     ! Level of detail printed,
                                     ! specifically for GRIB2 print 
                                     ! messages only.  Use if trying to 
                                     ! diagnose GRIB2 I/O problems.
                                     ! 0 = No output
                                     ! 1 = Print output
      end module verbose_output
c
      module waitfor_parms
        character*1 :: use_waitfor ! y or n, for waiting for input files
        integer(kind=8) :: wait_min_age    ! min age (in seconds)... time since
                                           ! last file modification
        integer(kind=8) :: wait_min_size   ! minimum file size in bytes
        integer(kind=8) :: wait_max_wait   ! max total wait time in seconds 
        integer(kind=8) :: wait_sleeptime  ! number of seconds to wait between 
                                           ! checks
        integer, parameter :: pfc_cmd_len = 800
        character*1 :: use_per_fcst_command ! enable per_fcst_command
        character(pfc_cmd_len) :: per_fcst_command ! command to run every forecast time
      end module waitfor_parms
c
      module netcdf_parms
        type netcdfstuff  ! Define a new type for NetCDF information
          ! All of these "name" variables are the names for the 
          ! different variables in the NetCDF file.
          integer ::   num_netcdf_vars ! Total *possible* 
                                  ! number of input NetCDF variables,
                                  ! including those that are included
                                  ! in the input file and those that
                                  ! are not.
          character*180 :: netcdf_filename ! character file name for 
                                           ! the NetCDF file.
          character*180 :: netcdf_lsmask_filename ! character file name
                                      ! for the optional, separate 
                                      ! NetCDF file if the user has 
                                      ! indicated this with the
                                      ! read_separate_land_mask_file
                                      ! flag.
          character*30 ::  rv850name  ! 850 mb rel vort
          character*30 ::  rv700name  ! 700 mb rel vort
          character*30 ::  u850name   ! 850 mb u-comp
          character*30 ::  v850name   ! 850 mb v-comp
          character*30 ::  u700name   ! 700 mb u-comp
          character*30 ::  v700name   ! 700 mb v-comp
          character*30 ::  z850name   ! 850 mb gp height
          character*30 ::  z700name   ! 700 mb gp height
          character*30 ::  mslpname   ! mslp
          character*30 ::  usfcname   ! near-sfc u-comp
          character*30 ::  vsfcname   ! near-sfc v-comp
          character*30 ::  u500name   ! 500 mb u-comp
          character*30 ::  v500name   ! 500 mb v-comp
          character*30 ::  tmean_300_500_name  ! Mean Temp in
                                               ! 300-500 mb layer
          character*30 ::  z500name   ! 500 mb gp height
          character*30 ::  z200name   ! 200 mb gp height
          character*30 ::  lmaskname  ! Land mask
          character*30 ::  z900name   ! 900 mb gp height
          character*30 ::  z800name   ! 800 mb gp height
          character*30 ::  z750name   ! 750 mb gp height
          character*30 ::  z650name   ! 650 mb gp height
          character*30 ::  z600name   ! 600 mb gp height
          character*30 ::  z550name   ! 550 mb gp height
          character*30 ::  z450name   ! 450 mb gp height
          character*30 ::  z400name   ! 400 mb gp height
          character*30 ::  z350name   ! 350 mb gp height
          character*30 ::  z300name   ! 300 mb gp height
          character*30 ::  time_name  ! Name of time variable,
                                      ! usually "time"
          character*30 ::  lon_name   ! longitudes
          character*30 ::  lat_name   ! latitudes
          character*30 ::  time_units ! "days" or "hours"
          character*30 ::  u200name   ! 200 mb u-comp
          character*30 ::  v200name   ! 200 mb v-comp
          character*30 ::  sstname    ! SST
          character*30 ::  q850name   ! 850 mb specific humidity
          character*30 ::  rh1000name ! 1000 mb RH
          character*30 ::  rh925name  ! 925 mb RH
          character*30 ::  rh800name  ! 800 mb RH
          character*30 ::  rh750name  ! 750 mb RH
          character*30 ::  rh700name  ! 700 mb RH
          character*30 ::  rh650name  ! 650 mb RH
          character*30 ::  rh600name  ! 600 mb RH
          character*30 ::  spfh1000name ! 1000 mb specific humidity
          character*30 ::  spfh925name ! 925 mb specific humidity
          character*30 ::  spfh800name ! 800 mb specific humidity
          character*30 ::  spfh750name ! 750 mb specific humidity
          character*30 ::  spfh700name ! 700 mb specific humidity
          character*30 ::  spfh650name ! 650 mb specific humidity
          character*30 ::  spfh600name ! 600 mb specific humidity
          character*30 ::  temp1000name ! 1000 mb temperature
          character*30 ::  temp925name ! 925 mb temperature
          character*30 ::  temp800name ! 800 mb temperature
          character*30 ::  temp750name ! 750 mb temperature
          character*30 ::  temp700name ! 700 mb temperature
          character*30 ::  temp650name ! 650 mb temperature
          character*30 ::  temp600name ! 600 mb temperature
          character*30 ::  omega500name ! 500 mb omega
        end type netcdfstuff
        real, save, allocatable :: netcdf_file_time_values(:)
        integer, save, allocatable :: nctotalmins(:)
      end module netcdf_parms
c---------------------------------------------------------------------c
c
