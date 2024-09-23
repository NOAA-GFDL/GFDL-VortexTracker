       program trakmain
c
c$$$  MAIN PROGRAM DOCUMENTATION BLOCK
c
c Main Program: GETTRK       Track model vortices   
C   PRGMMR: MARCHOK          ORG: NP22        DATE: 2002-05-20
c
c ABSTRACT: This program tracks the average of the max or min
c   of several parameters in the vicinity of an input
c   first guess (lat,lon) position of a vortex in order to give  
c   forecast position estimates for that vortex for a given numerical
c   model.  For the levels 700 & 850 mb, the tracked parameters are:
c   Relative vorticity (max), wind magnitude (min), and geopotential
c   height (min).  Also tracked is the min in the MSLP.  So many
c   parameters are tracked in order to provide more accurate position
c   estimates for weaker storms, which often have poorly defined
c   structures/centers.  Currently, the system is set up to be able
c   to process GRIB input data files from the GFS, MRF, UKMET, GDAS,
c   ECMWF, NGM, NAM and FNMOC/NAVGEM models.  Two 1-line files
c   are  output from this program, both containing the forecast fix
c   positions that the  tracker has obtained.  One of these  output 
c   files contains the positions at every 12 hours from forecast 
c   hour 0 to the end of the forecast. The other file is in ATCF 
c   format, which is the particular format needed by the Tropical
c   Prediction Center, and provides the positions at forecast hours
c   12, 24, 36, 48 and 72, plus the maximum wind near the storm center
c   at each of those forecast hours.
c
c Program history log:
c   98-03-16  Marchok - Original operational version.
c   98-07-15  Marchok - Added code to calculate radii of gale-, storm-,
c                       and hurricane-force winds in each quadrant.
c   99-04-01  Marchok - Added code to be able to read in 4-digit years
c                       off of the TC Vitals records.
c                       Added code, including subroutine  is_it_a_storm,
c                       to make a better determination of whether or 
c                       not the center that was found at each time is
c                       the center of a storm, and not just a passing
c                       vort max, etc.
c   99-06-15  Marchok - Fixed a bug in calcdist that was triggered by a
c                       rounding error sending a number just above 1 
c                       into ACOS to get the distance between 2 
c                       identical points (which, obviously, is 0).
c   00-06-20  Marchok - Added GDAS option for vortex relocation work.
c                       Changed nhalf from 3 to 5.  Relaxed the 
c                       requirements for pthresh and vthresh.
c   00-11-30  Marchok - Added ability to handle GFDL and NCEP Ensemble
c                       model data.  Extended time range to be able to
c                       handle 5-day capability.  Forecast hours are 
c                       now input via a namelist (easiest way to account
c                       for NAM, GFS and GFDL having different forecast
c                       lengths at 00/12z and 06/18z).  Model ID's are 
c                       now input via a namelist (makes it easier, for
c                       example, to run for many different ensemble 
c                       members).  Added new output, the atcfunix 
c                       format, needed for 5-day forecasts.
c   01-08-24  Marchok   Fixed a bug in rvcal and getgridinfo.  When a 
c                       grid that was south-->north is flipped in 
c                       conv1d2d_real to be north-->south, the scanning 
c                       mode flag remains 64 and what we would consider
c                       the max and min latitudes are reversed, so I 
c                       added code to correct this in both routines.
c   02-05-20  Marchok   Weakened the mslp gradient threshold and v850
c                       threshold in is_it_a_storm to cut down on the
c                       number of dropped storms.
c   03-03-18  Marchok   Fixed a bug in get_ij_bounds that was allowing
c                       a cos(90) and cos(-90), which then led to a
c                       divide by zero.
c   05-08-01  Marchok   Updated to allow tracking of ECMWF hi-res, ECMWF
c                       ensemble, CMC hi-res, CMC ensemble, NCEP
c                       ensemble.
c   06-11-07  Marchok   Updated to locate, and report to the atcfunix
c                       file, the value of the gridpoint minimum value
c                       of mslp.  Previously, the  barnes-averaged
c                       value had been used.
c   08-01-10  Marchok   Changed the storm ID for genesis tracking so
c                       that the ID includes info
c                       on storm detection location & time.  Added
c                       algorithms for Hart's cyclone phase space.
c                       Added new output fields to the atcfunix
c                       records, actually creating a modified atcfunix
c                       record, to include things such as the mean &
c                       max values of zeta850 & zeta700 centered on
c                       the storm, the speed & direction of storm
c                       translation, and the Hart CPS parameters.
c   10-01-07  Marchok   - input grib lead time can be hrs or minutes
c                       - added code for warm core check
c                       - added code to detect genesis
c                       - added code to report on sfc wind structure
c                       - added buffer ("grid_buffer") to avoid fixing
c                         center to boundaries on regional grids
c                       - modified rvcal to report missing zeta values
c                         as background coriolis instead of -999, since
c                         the -999 was messing up center-fixing
c                       - added 10-m wind and sfc zeta as center-fixing
c                         parms.
c
c   10-05-25  Slocum    Add verbose feature to code
c                       0 = Not terminal output, 1 = error messages only
c                       2 = all output
c
c   10-05-26  Marchok   - added flags and code to check the temporal 
c                         consistency of the mslp closed contour and 
c                         Vt850 checks for tcgen and midlat cases.
c
c   13-04-01  Marchok   Added code to upgrade the wind radii diagnosid.
c                       Hurricane Sandy exposed an issue with the
c                       tracker for large storms.  The code was modified
c                       to use an iterative technique that can 
c                       diagnose radii for large storms but still 
c                       accurately diagnost radii for small storms.  See
c                       subroutine  getradii for more details.
c
c   15-11-01  Marchok   Replaced the routine which tracks the wind 
c                       minimum at the center of a storm, as that 
c                       routine proved troublesome with very hi-res 
c                       grids (0.02-deg) from HWRF for very small 
c                       storms.  This has been replaced with a routine
c                       that looks for "wind circulation difference", 
c                       whereby the center for this parm is located at
c                       the spot where the tangential wind circulation
c                       minus the wind magnitude at the candidate 
c                       center position is maximized.  ALSO: Added in 
c                       tracking of thickness as an additional 
c                       tracked parm. ALSO: Added a separate verbose
c                       flag for only the GRIB2 read diagnostics, which
c                       can be voluminous.
c
c   16-09-01  Marchok   Added in the ability to read in NetCDF files.
c                       As with GRIB data, the NetCDF data must be on 
c                       a lat/lon grid.
c
c   17-08-31  Marchok   Added a logical bitmap capability for NetCDF 
c                       files to prevent the accessing of missing data.
c                       Also modified the code to permit more accurate
c                       reporting of the grid point value of the 
c                       minimum SLP for reporting to the atcfunix file.
c                       Finally, fixed a bug (reported by JTWC) whereby
c                       radii were being reported for thresholds that
c                       were in exceedance of the  tracker-diagnosed
c                       Vmax (e.g., 34-kt radii for a storm with 
c                       Vmax = 25 kts).
c
c   19-05-29  Marchok   Only do the check for 50- and 64-kt radii the
c                       first time through the  getradii routine.  The
c                       34-kt radii may be adjusted on subsequent calls.
c
c                       Adjusted code to allow for forward tracking for
c                       NetCDF data files that do not have hour0 data 
c                       in them.
c
c                       Code updated to include cyclone phase space
c                       analysis for 00h.  Previously this was not done
c                       since storm motion direction is needed for 
c                       Parameter B.  This is now included for forward
c                       tracking cases (i.e., cases in which we have TC
c                       Vitals), and we use the storm motion as reported
c                       from the TC Vitals.  Of course, the observed 
c                       motion from TC Vitals may not exactly match the
c                       model forecast motion, but for 00h it will be
c                       close enough that it will allow us to get the
c                       CPS diagnostics.  This was a request from Chris
c                       Velden for use with the latest version of AODT.
c                       For genesis cases (trkrtype = midlat or tcgen),
c                       CPS diagnostics are still not performed at the
c                       first detection lead time.
c
c                       In subroutine get_sfc_center, replaced double-
c                       weighting for surface wind circulation fix with
c                       single weighting, as results of testing did not
c                       support the use of double weighting.
c
c                       Modified code in subroutine  getvrvt to properly
c                       handle the computation of radial and tangential
c                       winds when a storm is near the Greenwich
c                       Meridian.
c
c                       Made significant changes to subroutine
c                       get_next_ges to fix issues for cases that are
c                       near or crossing the Greenwich meridian.
c
c                       Made changes to subroutine get_max_wind to allow
c                       for checking of the max wind at points closer to
c                       the border of a regional grid.  Previously, the
c                       last few points were not sampled in order to
c                       avoid numerical issues with sampling points at
c                       the boundary.  This change was added in response
c                       to a request from HRD for use with a regional
c                       version of fv3 (hfvgfs).
c
c                       Made a substantial change to the algorithm that
c                       returns the value of the wind circulation in
c                       subroutine get_wind_circulation.  Previously,
c                       a difference was computed between the radially-
c                       integrated wind circulation and the wind
c                       magnitude at the center of the storm.  This was
c                       flawed.  Now, just the value of the radially-
c                       integrated wind circulation is used, and the
c                       results are robust and comparable to those of
c                       using relative vorticity. 
c
c                       Bug fix in subroutine getcorr related to the
c                       correlation residuals.
c
c   19-09-03  Marchok   Made a change to subroutine  getgridinfo to 
c                       allow a particular longitude specification to
c                       be okay.  Previously, if the grid max west lon
c                       was > 0 and the grid max east long was also > 0,
c                       but if glonmin > glonmax (for example, a grid
c                       that spans across the GM going from 265E to 5E),
c                       the code was written to assume the user had 
c                       coded the grid specification incorrectly.  This
c                       condition is now allowed.
c
c   20-10-02  Marchok   Made a substantial change for fixed regional 
c                       grids (e.g., HAFS-A/B, T-SHiELD) in how the 
c                       tracker decides to stop tracking when a storm
c                       is near the grid boundary.  This was in response
c                       to an issue with these models for the  tracker 
c                       continuing to track noise after a storm had left
c                       the grid boundary, and the track would appear to
c                       "crawl" along the boundary.  Added two new
c                       checks for storms that are within 350 km of the
c                       grid boundary or invalid / null data on a fixed
c                       regional grid.  One check is for a closed MSLP
c                       contour, one is to check for mean, cyclonic Vt
c                       at 850 mb in *each* of 4 quadrants around a 
c                       storm.  Two new subroutines were added: 
c                       probe_for_boundary and check_quadrant_wind_circ.
c
c   20-10-16  Marchok   Uncovered an issue with the grid edges for HWRF
c                       not being consistent in their coverage between
c                       the u&v and MSLP variables.  Because of the 
c                       native semi-staggered grid, after interpolation
c                       to the lat/lon tracker grid, the u&v variables
c                       extend to a couple points here & there at the
c                       grid boundaries where there is no corresponding
c                       MSLP data.  Because I only bring the bitmap in
c                       once (from the u850 data), there are some edge
c                       points that are listed as being valid data 
c                       points but which have missing (-999) MSLP data,
c                       and this screws up the routine (fix_latlon_ij)
c                       that returns the value of the lowest grid point
c                       MSLP value for reporting to the ATCF file.  To
c                       address this, I added an argument, "stopcheck",
c                       to the call fo fix_latlon_ij, and if 
c                       stopcheck = gptmslp (to indicate a check for 
c                       gridpoint mslp), if a mslp value is < 0, it
c                       is skipped.  This now helps HWRF avoid getting
c                       -999 values in the MSLP field for the above
c                       situation.
c
c                       Also addressed an issue for HMON having -99
c                       values for MSLP.  This is different from the 
c                       above HWRF issue, and this one was due to 
c                       the MSLP record missing for a given lead 
c                       time.  Not much we can do there, but I made
c                       sure in output_atcfunix by assigning a value
c                       of 0 to xminmslp that the output MSLP
c                       will also have a zero value.
c
c   21-10-20  Marchok   Fixed 2 bugs.  The first was a critical bug with
c                       relative vorticity specifically for cases in 
c                       which NetCDF data was being used *AND* if 
c                       phaseflag=y.  In those cases, the vorticity data
c                       arrays were filled with junk values, leading to 
c                       erroneous center-fixing for vorticity (again,
c                       *ONLY* when using NetCDF data and phaseflag=y).
c                       The 2nd bug was a problem in 2 different areas
c                       of the code (subroutines getvrvt and
c                       bilin_int_uneven) with how Greenwich Meridian
c                       wrapping was being handled.  I fixed the 
c                       GM-wrapping in a few different areas in both
c                       subroutines.
c
c   23-07-31  Marchok   Fixed an error in output_atcfunix where I had 
c                       an extra comma in the output record.
c
c   24-05-14  McAlli.   Adds unit test capabilities; in order to have this
c                       a module wrapper must be placed around all the 
c                       subroutines. The main program and all subroutines
c                       have been placed in seperate files for this to work.
c
c
c Input files:
c   unit   11    Unblocked GRIB1 file containing model data
c   unit   12    Text file containing TC Vitals card for current time
c   unit   31    Unblocked GRIB index file
c
c Output files:
c   unit   61    Output file with forecast positions every 12h from 
c                vt=00h to the end of the forecast
c   unit   62    Output file in ATCF format, with forecast positions
c                at vt = 12, 24, 36, 48 and 72h, plus wind speeds.
c   unit   63    Output file with forecast wind radii for 34, 50 and
c                64 knot thresholds in each quadrant of each storm.
c
c Subprograms called:
c   read_nlists  Read input namelists for input date & storm number info
c   read_tcv_card Read TC vitals file to get initial storm position
c   getgridinfo  Read GRIB file to get basic grid information
c   tracker      Begin main part of tracking algorithm
c
c Attributes:
c   Language: Standard Fortran_90
c
c$$$
c
c-------
c
c     LOCAL:
c
c     ifhours:   Integer array holding numerical forecast times for
c                the input model (99 = no more times available).
c                These values are read in via a namelist.
c     Model numbers used: (1) GFS, (2) MRF, (3) UKMET, (4) ECMWF,
c                (5) NGM, (6) NAM, (7) NAVGEM, (8) GDAS,
c                (10) NCEP Ensemble, (11) ECMWF Ensemble (13) SREF
c                Ensemble, (14) NCEP Ensemble (from ensstat mean
c                fields), (15) CMC, (16) CMC Ensemble, (17) HWRF,
c                (18) HWRF Ensemble, (19) HWRF-DAS (HDAS),
c                (20) Ensemble RELOCATION (21) UKMET hi-res (NHC)
c                (23) FNMOC Ensemble
c     stormswitch:  This switch tells how to handle each storm in 
c                the TCV file:
c                1 = process this storm for this forecast hour.
c                2 = Storm was requested to be tracked, but either
c                    the storm went off the grid (regional models),
c                    the storm dissipated, or the program was
c                    unable to track it.
c                3 = Storm was NOT requested to be tracked at all.
c     storm:     An array of type tcvcard.  Each member of storm 
c                contains a separate TC Vitals card.
c     maxstorm:  Maximum number of storms the system is set up to 
c                handle at any 1 time.
c     slonfg,slatfg:  Holds first guess positions for storms.  The 
c                very first, first guess position is read from the
c                TC vitals card. (maxstorm,maxtime)
c     clon,clat: Holds the coordinates for the center positions for
c                all storms at all times for all parameters.
c                (max_#_storms, max_fcst_times, max_#_parms)
c
      USE def_vitals; USE inparms; USE set_max_parms; USE level_parms
      USE trig_vals; USE atcf; USE trkrparms; USE verbose_output
      USE netcdf_parms; USE access_subroutines
c
      implicit none
c
      logical(1) file_open
      integer date_time(8)
      character (len=10) big_ben(3)
      character :: ncfile*180,ncfile_has_hour0*1
      character :: nc_lsmask_file*180
      character :: opening_mask*1
      integer :: vortex_tilt_levs(100)
      integer itret,iggret,iicret,igcret,iret,ifhmax,maxstorm,numtcv
      integer micret,mgcret,num_vortex_tilt_levs
      integer iocret,enable_timing,ncfile_id,ncfile_tmax,irnhret
      integer nc_lsmask_file_id
      integer, parameter :: lugb=11,lugi=31,lucard=12,lgvcard=14,lout=51
      integer, parameter :: lmgb=22,lmgi=42
      integer, parameter :: lunml=555
c
      type (datecard) inp
      type (trackstuff) trkrinfo
      type (netcdfstuff) netcdfinfo

c     --------------------------------------------------------

      call date_and_time (big_ben(1),big_ben(2),big_ben(3),date_time)
      write (6,31) date_time(5),date_time(6),date_time(7)
  31  format (1x,'TIMING: beginning ...  ',i2.2,':',i2.2,':',i2.2)

c      call w3tagb('GETTRK  ',1999,0104,0058,'NP22   ')

      pi = 4. * atan(1.)   ! Both pi and dtr were declared in module 
      dtr = pi/180.0       ! trig_vals, but were not yet defined.
      ncfile_has_hour0 = 'n'  ! Default value; set in read_netcdf_hours
      vortex_tilt_levs = -999
c
      call read_nlists (inp,trkrinfo,netcdfinfo,vortex_tilt_levs
     &                 ,num_vortex_tilt_levs,lunml)
      enable_timing=trkrinfo%enable_timing

      call read_fhours (ifhmax)

      call read_tcv_card (lucard,maxstorm,trkrinfo,numtcv,iret)

      if (iret == 0) then
        if ( verb .ge. 3 ) then
          print *,'After read_tcv_card, num vitals = ',numtcv
        endif
      else
        if ( verb .ge. 1 ) then
         print '(/,a50,i4,/)','!!! ERROR: in read_tcv_card, rc= ',iret
        endif
        goto 890
      endif

      call read_gen_vitals (lgvcard,maxstorm,trkrinfo,numtcv,iret)

      if (iret == 0) then
        if ( verb .ge. 3 ) then
          print *,'After read_gen_vitals, total number of vitals (both'
     &         ,' TC and non-TC) now = ',numtcv
        endif
      else
        if ( verb .ge. 1 ) then
          print '(/,a50,i4,/)','!!! ERROR: in read_gen_vitals, rc= '
     &         ,iret
        endif
        goto 890
      endif

      if (inp%file_seq == 'onebig') then
        if (trkrinfo%inp_data_type == 'netcdf') then
          ncfile = netcdfinfo%netcdf_filename
          print *,' '
          print *,'before open_ncfile call, ncfile= ',ncfile
          call open_ncfile (ncfile,ncfile_id)
          print *,'after open_ncfile call, ncfile_id= ',ncfile_id
          call read_netcdf_hours (ncfile,ncfile_id,ncfile_tmax,ifhmax
     &                           ,ncfile_has_hour0,netcdfinfo,irnhret)
          if (irnhret /= 0) then
            print *,'(/,a32,a5,i4,/)','!!! ERROR: in read_netcdf_hours,'
     &             ,' rc= ',irnhret
            goto 890
          endif
          if (trkrinfo%read_separate_land_mask_file == 'y') then
            nc_lsmask_file = netcdfinfo%netcdf_lsmask_filename
            print *,' '
            print *,'before open_ncfile call for lsmask, '
     &             ,'nc_lsmask_file= ',nc_lsmask_file
            call open_ncfile (nc_lsmask_file,nc_lsmask_file_id)
            print *,'after open_ncfile call for lsmask, '
     &             ,'nc_lsmask_file_id= ',nc_lsmask_file_id
          else
            nc_lsmask_file_id = -999
          endif
        else
          opening_mask = 'n'
          call open_grib_files (inp,lugb,lugi,'dummy','dummy',lout
     &                          ,opening_mask,iret)
          if (iret /= 0) then
            print '(/,a50,i4,/)','!!! ERROR: in open_grib_files, rc= '
     &             ,iret
            print '(/,a10,i4,a7,i4/)','!!! lugb= ',lugb,' lugi= ',lugi
            goto 890
          endif
          if (trkrinfo%read_separate_land_mask_file == 'y') then
            opening_mask = 'y'
            call open_grib_files (inp,lmgb,lmgi,'dummy','dummy',lout
     &                           ,opening_mask,iret)
            if (iret /= 0) then
              print '(/,a29,a29,i4,/)','!!! ERROR: in open_grib_files'
     &               ,' for land-sea mask file, rc= '
     &               ,iret
              print '(/,a10,i4,a7,i4/)','!!! lmgb= ',lmgb,' lmgi= ',lmgi
              goto 890
            endif
          endif
        endif
      endif

      call tracker (inp,maxstorm,numtcv,ifhmax,trkrinfo,ncfile
     &             ,ncfile_id,nc_lsmask_file,nc_lsmask_file_id
     &             ,netcdfinfo,ncfile_has_hour0,ncfile_tmax
     &             ,vortex_tilt_levs,num_vortex_tilt_levs,itret)
c
890   continue

      igcret=0
      iicret=0
      iocret=0
      mgcret=0
      micret=0

      inquire (unit=lugb, opened=file_open)
      if (file_open) call baclose(lugb,igcret)
      inquire (unit=lugi, opened=file_open)
      if (file_open) call baclose(lugi,iicret)
      inquire (unit=lmgb, opened=file_open)
      if (file_open) call baclose(lmgb,igcret)
      inquire (unit=lmgi, opened=file_open)
      if (file_open) call baclose(lmgi,iicret)
      inquire (unit=lout, opened=file_open)
      if (file_open) call baclose(lout,iocret)
      if ( verb .ge. 3 ) then
        print *,'baclose: igcret= ',igcret,' iicret= ',iicret
        print *,'baclose: iocret= ',iocret
        print *,'baclose: mgcret= ',mgcret,' micret= ',micret
      endif
c      call w3tage('GETTRK  ')
c
      stop
      end
