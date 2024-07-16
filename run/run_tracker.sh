#!/bin/ksh --login
#SBATCH -o output/07-09_pt2.out
#SBATCH -J findvariables
#SBATCH --export=ALL
#SBATCH --time=59   # time limit in minutes
#SBATCH --mem-per-cpu=8G
#SBATCH --ntasks=1
#SBATCH --partition=analysis

#--------------------------------------------------------------
# Script written by Tim Marchok --> timothy.marchok@noaa.gov
# Edited by Caitlyn McAllister  --> caitlyn.mcallister@noaa.gov
#--------------------------------------------------------------

export PS4=' + run_tracker.sh line $LINENO: '

module purge
. /usr/local/Modules/5.1.1/init/ksh

# loads any module/packages needed for cmake build
cd ../modulefiles
source modulefile.$target

echo " "
module list
echo " "


echo " "
echo "LD_LIBRARY_PATH= $LD_LIBRARY_PATH"
echo " "

# this has to be changed depending on what computer user is on
# put this in setup script
export ncdump=/app/spack/2023.02/linux-rhel7-x86_64/intel-2021.7.1/netcdf-c/4.9.2-pvuitvtd4ixig2ldwtx2qlqkkefh4ora/bin/ncdump

ulimit -c unlimited

#-----------------------------------------------------------
# Set critical initial variables and directories
#-----------------------------------------------------------

export curymdh=2023082900 # date of netcdf info
export cmodel=tshd # need this for regular tracker run

export home=/home/Caitlyn.Mcallister/findvariables/
export rundir=${home}/run/
export execdir={home}/exec/gettrk.x
export workroot=/work/Caitlyn.Mcallister/findvariables
# CAITLYN is this used?
export ncdf_ls_mask_filename=${rundir}/SLMSKsfc_T-SHiELD_C768r10n4_atl_new.RT2021_k21d_GFSv16_gaea.nc

export tcvit_date=${home}/files/bin/tcvit_date
export NDATE=${home}/files/bin/ndate.x

export gribver=1
export basin=al
#export trkrtype=tracker
export trkrtype=tcgen

export outdir_tag=cmtrakout
wdir=${workroot}/${outdir_tag}/${curymdh}/${cmodel}
if [ ! -d ${wdir} ]; then mkdir -p ${wdir}; fi

set +x
echo " "
echo "+++ Top of run_tshd_ez.sh, time= `date`"
echo "    curymdh=    $curymdh"
echo "    cmodel=     $cmodel"
echo "    trkrtype=   $trkrtype"
echo "    outdir_tag= ${outdir_tag}"
echo "    gribver=    ${gribver}"
echo "    wdir=       ${wdir}"
echo " "
set -x

set -x

export PDY=`     echo $curymdh | cut -c1-8`
export yyyy=`    echo $curymdh | cut -c1-4`
export cyc=`     echo $curymdh | cut -c9-10`
export ymdh=${PDY}${cyc}

export wdir=${workroot}/${outdir_tag}/${PDY}${cyc}/${cmodel}
export DATA=${workroot}/${outdir_tag}/${PDY}${cyc}/${cmodel}

if [ ! -d ${workroot} ]; then mkdir -p ${workroot}; fi
if [ ! -d ${wdir} ];     then mkdir -p ${pdir}; fi

cd $wdir

tshddir=/archive/Alex.Kaltenbaugh/NGGPS/T-SHiELD_rt2023/${PDY}.${cyc}Z.C768r10n4_atl_new.RT2022_k22dv1_GFSv16_kjet/pp

#----------------------------------------------------
# Check the TC Vitals to see if there are any 
# observed storms for the input ymdh.
#----------------------------------------------------

tcvit_logfile=${rundir}/tcvit_logfile.${yyyy}.txt

if [ ${trkrtype} == 'tracker' ]; then

  if [ ${cmodel} == 'tshd' ]; then
    ${tcvit_date} ${curymdh} | grep "NHC"                 | \
    grep -v TEST | awk 'substr($0,6,1) !~ /8/ {print $0}'   \
    >${wdir}/vitals.${curymdh}
  elif [ ${cmodel} == 'shld' ]; then
    ${tcvit_date} ${curymdh} | egrep "JTWC|NHC"           | \
    grep -v TEST | awk 'substr($0,6,1) !~ /8/ {print $0}'   \
    >${wdir}/vitals.${curymdh}
  fi

elif [ ${trkrtype} = 'tcgen' -o ${trkrtype} = 'midlat' ]; then

  # For a genesis run of the tracker, the tracker will try to find 
  # new storms that develop in the model.  Therefore, it's not 
  # necessary to have any TC vitals to try to track already-numbered
  # storms, but it will do so if any already known storms exist.  

  ${tcvit_date} ${curymdh} | egrep "JTWC|NHC"             | \
    grep -v TEST | awk 'substr($0,6,1) !~ /8/ {print $0}'   \
    >${wdir}/vitals.${curymdh}

fi

num_storms=` cat ${wdir}/vitals.${curymdh} | wc -l`

# A quirk of the I/O for the tracker program is that the 
# vitals file must exist, even if it's empty (i.e., there 
# are no storms).  So this next IF statement checks to see if there 
# are any storms for the current YMDH.  If there are, then we simply 
# continue after catting the vitals file out for display in the 
# output file.  If storms do not exist, then do a touch to just 
# create an empty file.

if [ ${num_storms} -gt 0 ]; then
  set +x
  echo " "
  echo "+++ ${num_storms} Observed storms exist for ${curymdh}: " | tee -a  ${tcvit_logfile}
  cat ${wdir}/vitals.${curymdh}
  cat ${wdir}/vitals.${curymdh} >> ${tcvit_logfile}
  echo " "
  set -x
else
  touch ${wdir}/vitals.${curymdh}
fi

#------------------------------------------------------------------------
# Set variables & parameters for the input namelist for T-SHiELD...
#------------------------------------------------------------------------

export trkrebd=339.0   # boundary only used by tracker if trkrtype = tcgen or midlat
export trkrwbd=260.0   # boundary only used by tracker if trkrtype = tcgen or midlat
export trkrnbd=40.0    # boundary only used by tracker if trkrtype = tcgen or midlat
export trkrsbd=7.0     # boundary only used by tracker if trkrtype = tcgen or midlat
export regtype=altg    # This variable is only needed if trkrtype = tcgen or midlat

COM=${DATA}            
atcfnum=15             
atcfname="tgbt"        
atcfout="tgbt"         
atcfymdh=${PDY}${cyc}  
max_mslp_850=400.0
mslpthresh=0.0015      
v850thresh=1.5000      
v850_qwc_thresh=1.0000 
cint_grid_bound_check=0.50     
modtyp='regional'    
nest_type='fixed'    
export WCORE_DEPTH=1.0
export PHASEFLAG=y      
export PHASE_SCHEME=both  
#export PHASE_SCHEME=vtt
#export PHASE_SCHEME=cps
export STRUCTFLAG=y     
export IKEFLAG=y        
export genflag=y       
export sstflag=y      
export shear_calc_flag=y

export gen_read_rh_fields=n   
# export use_land_mask=y     
# export read_separate_land_mask_file=y  
export use_land_mask=n     
export read_separate_land_mask_file=n  
export need_to_compute_rh_from_q=y  
export smoothe_mslp_for_gen_scan=y 
atcfnum=15     
atcffreq=600   
rundescr="xxxx"     
atcfdescr="xxxx"    
file_sequence="onebig"  
# For netCDF files, the lead time units are determined below in 
# an ncdump scan of the file, so leave this blank.
lead_time_units=' '    
#       gribver=2     # N/A since we are using NetCDF data for T-SHiELD;
# g2_jpdtn sets the variable that will be used as "JPDTN" for
# the call to getgb2, if gribver=2.  jpdtn=1 for ens data,
# jpdtn=0 for deterministic data.
g2_jpdtn=0       
inp_data_type=netcdf   
model=41        

ATCFNAME=` echo "${atcfname}" | tr '[a-z]' '[A-Z]'`

export atcfymdh=${PDY}${cyc}

export use_land_mask=${use_land_mask:-no}
# contour_interval=100.0
contour_interval=1.0
radii_pctile=95.0
radii_free_pass_pctile=67.0
radii_width_thresh=15.0
# radii_width_thresh=30.0
write_vit=n
want_oci=.TRUE.
use_backup_mslp_grad_check=${use_backup_mslp_grad_check:-y}
use_backup_850_vt_check=${use_backup_850_vt_check:-y}

# These next definitions declare the names of the variables inside
# the T-SHiELD files.  This allows the tracker to know the exact 
# name of the record to look for.

ncdf_num_netcdf_vars=999  
ncdf_rv850name="X"        
ncdf_rv700name="X"        
ncdf_u850name="u850"      
ncdf_v850name="v850"      
ncdf_u700name="u700"      
ncdf_v700name="v700"      
ncdf_z850name="h850"      
ncdf_z700name="h700"      
ncdf_mslpname="PRMSL"     
ncdf_usfcname="UGRD10m"   
ncdf_vsfcname="VGRD10m"   
ncdf_u500name="u500"      
ncdf_v500name="v500"     
ncdf_u200name="u200"    
ncdf_v200name="v200"   
ncdf_tmean_300_500_name="TMP500_300"  
ncdf_z500name="X"       
ncdf_z200name="X"          
ncdf_lmaskname="SLMSKsfc" 
ncdf_z900name="h900"     
ncdf_z800name="h800"     
ncdf_z750name="h750"     
ncdf_z650name="h650"     
ncdf_z600name="h600"    
ncdf_z550name="h550"   
ncdf_z500name="h500"  
ncdf_z450name="h450" 
ncdf_z400name="h400"         
ncdf_z350name="h350"        
ncdf_z300name="h300"       
ncdf_time_name="time"     
ncdf_lon_name="grid_xt"  
ncdf_lat_name="grid_yt" 
ncdf_sstname="TMPsfc"  
ncdf_q850name="q850"  
ncdf_rh1000name="X"  
ncdf_rh925name="X"       
ncdf_rh800name="X"      
ncdf_rh750name="X"     
ncdf_rh700name="X"    
ncdf_rh650name="X"   
ncdf_rh600name="X"  
ncdf_spfh1000name="q1000"  
ncdf_spfh925name="q925"    
ncdf_spfh800name="q800"    
ncdf_spfh750name="q750"    
ncdf_spfh700name="q700"    
ncdf_spfh650name="q650"    
ncdf_spfh600name="q600"    
ncdf_temp1000name="t1000"  
ncdf_temp925name="t925"    
ncdf_temp800name="t800"    
ncdf_temp750name="t750"   
ncdf_temp700name="t700"   
ncdf_temp650name="t650"   
ncdf_temp600name="t600"   
ncdf_omega500name="omg500"  


#-----------------------------------------------------------------------
# Now define what the input NetCDF files are named and then process
# the different files to pull out just the records we need from the 
# original NetCDF file, using ncks, and combine them into one file.
#-----------------------------------------------------------------------

fv3_atmos_file=atmos_sos.nest02.tile7_nested_ltd.nc
fv3_2d_file=nggps2d.nest02.tile7_nested_ltd.nc

if [ -s ${wdir}/tshield.${PDY}${cyc}.nc ]; then

  set +x
  echo " "
  echo " +++ Processed T-SHiELD files already.  NOT doing ncks stuff...."
  echo " "
  set -x

else

  netcdf_temp_file_1=${wdir}/netcdf_temp_atmos.${PDY}${cyc}.nc
  netcdf_temp_file_2=${wdir}/netcdf_temp_nggps.${PDY}${cyc}.nc
  netcdf_combined_file=${wdir}/tshield.${PDY}${cyc}.nc

  if [ -s ${netcdf_temp_file_1} ]; then rm ${netcdf_temp_file_1}; fi
  if [ -s ${netcdf_temp_file_2} ]; then rm ${netcdf_temp_file_2}; fi
  if [ -s ${netcdf_combined_file} ]; then rm ${netcdf_combined_file}; fi

  ncks --fl_fmt=64bit -F -v u850,u700,u500,u200,v850,v700,v500,v200,h900,h850,h800,h750,h700,h650,h600,h550,h500,h450,h400,h350,h300,h200,TMP500_300,q1000,q925,q850,q800,q750,q700,q650,q600,t1000,t925,t800,t750,t700,t650,t600,PRMSL,omg500 ${tshddir}/${fv3_atmos_file} ${netcdf_combined_file} || exit 1
  ncks --fl_fmt=64bit -F -A -v UGRD10m,VGRD10m,TMPsfc ${tshddir}/${fv3_2d_file} ${netcdf_combined_file} || exit 1

fi

netcdffile=${wdir}/tshield.${PDY}${cyc}.nc

# This next ncdf_time_units variable is going to either be
# "hours" or "days".  If it's "hours", then all the time data
# values are for hours since the initial time.  Same thing
# for "days", however if it is "days", then know that a value
# of 0.25 will be the same as a 6-hour lead time.

ncdf_time_units=` ${ncdump} -h ${netcdffile} | \
                  grep "time:units"          | \
                  awk -F= '{print $2}'       | \
                  awk -F\" '{print $2}'      | \
                  awk '{print $1}'`
set +x                          
echo " "                        
echo "NetCDF time units pulled from data file = ${ncdf_time_units}" 
echo " "                        
set -x

#####################################################
# Populate the namelist, using the variables that 
# were declared above.
#####################################################

namelist=${DATA}/input.${atcfout}.${PDY}${cyc}

echo "&datein inp%bcc=${scc},inp%byy=${syy},inp%bmm=${smm},"      >${namelist}
echo "        inp%bdd=${sdd},inp%bhh=${shh},inp%model=${model}," >>${namelist}
echo "        inp%modtyp='${modtyp}',"                           >>${namelist}
echo "        inp%lt_units='${lead_time_units}',"                >>${namelist}
echo "        inp%file_seq='${file_sequence}',"                  >>${namelist}
echo "        inp%nesttyp='${nest_type}'/"                       >>${namelist}
echo "&atcfinfo atcfnum=${atcfnum},atcfname='${ATCFNAME}',"      >>${namelist}
echo "          atcfymdh=${atcfymdh},atcffreq=${atcffreq}/"      >>${namelist}
echo "&trackerinfo trkrinfo%westbd=${trkrwbd},"                  >>${namelist}
echo "      trkrinfo%eastbd=${trkrebd},"                         >>${namelist}
echo "      trkrinfo%northbd=${trkrnbd},"                        >>${namelist}
echo "      trkrinfo%southbd=${trkrsbd},"                        >>${namelist}
echo "      trkrinfo%type='${trkrtype}',"                        >>${namelist}
echo "      trkrinfo%mslpthresh=${mslpthresh},"                  >>${namelist}
echo "      trkrinfo%use_backup_mslp_grad_check='${use_backup_mslp_grad_check}',"  >>${namelist}
echo "      trkrinfo%max_mslp_850=${max_mslp_850},"              >>${namelist}
echo "      trkrinfo%v850thresh=${v850thresh},"                  >>${namelist}
echo "      trkrinfo%v850_qwc_thresh=${v850_qwc_thresh},"        >>${namelist}
echo "      trkrinfo%use_backup_850_vt_check='${use_backup_850_vt_check}',"  >>${namelist}
echo "      trkrinfo%gridtype='${modtyp}',"                      >>${namelist}
echo "      trkrinfo%enable_timing=1,"                           >>${namelist}
echo "      trkrinfo%contint=${contour_interval},"               >>${namelist}
echo "      trkrinfo%want_oci=${want_oci},"                      >>${namelist}
echo "      trkrinfo%out_vit='${write_vit}',"                    >>${namelist}
echo "      trkrinfo%use_land_mask='${use_land_mask}',"          >>${namelist}
echo "      trkrinfo%read_separate_land_mask_file='${read_separate_land_mask_file}',"   >>${namelist}
echo "      trkrinfo%inp_data_type='${inp_data_type}',"          >>${namelist}
echo "      trkrinfo%gribver=${gribver},"                        >>${namelist}
echo "      trkrinfo%g2_jpdtn=${g2_jpdtn},"                      >>${namelist}
echo "      trkrinfo%g2_mslp_parm_id=${g2_mslp_parm_id},"        >>${namelist}
echo "      trkrinfo%g1_mslp_parm_id=${g1_mslp_parm_id},"        >>${namelist}
echo "      trkrinfo%g1_sfcwind_lev_typ=${g1_sfcwind_lev_typ},"  >>${namelist}
echo "      trkrinfo%g1_sfcwind_lev_val=${g1_sfcwind_lev_val}/"  >>${namelist}
echo "&phaseinfo phaseflag='${PHASEFLAG}',"                      >>${namelist}
echo "           phasescheme='${PHASE_SCHEME}',"                 >>${namelist}
echo "           wcore_depth=${WCORE_DEPTH}/"                    >>${namelist}
echo "&structinfo structflag='${STRUCTFLAG}',"                   >>${namelist}
echo "            ikeflag='${IKEFLAG}',"                         >>${namelist}
echo "            radii_pctile=${radii_pctile},"                 >>${namelist}
echo "            radii_free_pass_pctile=${radii_free_pass_pctile},"  >>${namelist}
echo "            radii_width_thresh=${radii_width_thresh}/"     >>${namelist}
echo "&fnameinfo  gmodname='${atcfname}',"                       >>${namelist}
echo "            rundescr='${rundescr}',"                       >>${namelist}
echo "            atcfdescr='${atcfdescr}'/"                     >>${namelist}
echo "&cintinfo contint_grid_bound_check=${cint_grid_bound_check}/" >>${namelist}
echo "&waitinfo use_waitfor='n',"                                >>${namelist}
echo "          wait_min_age=10,"                                >>${namelist}
echo "          wait_min_size=100,"                              >>${namelist}
echo "          wait_max_wait=1800,"                             >>${namelist}
echo "          wait_sleeptime=5,"                               >>${namelist}
echo "          per_fcst_command=''/"                            >>${namelist}
echo "&netcdflist netcdfinfo%num_netcdf_vars=${ncdf_num_netcdf_vars}," >>${namelist}
echo "      netcdfinfo%netcdf_filename='${netcdffile}',"                   >>${namelist}
echo "      netcdfinfo%netcdf_lsmask_filename='${ncdf_ls_mask_filename}'," >>${namelist}
echo "      netcdfinfo%rv850name='${ncdf_rv850name}',"             >>${namelist}
echo "      netcdfinfo%rv700name='${ncdf_rv700name}',"             >>${namelist}
echo "      netcdfinfo%u850name='${ncdf_u850name}',"               >>${namelist}
echo "      netcdfinfo%v850name='${ncdf_v850name}',"               >>${namelist}
echo "      netcdfinfo%u700name='${ncdf_u700name}',"               >>${namelist}
echo "      netcdfinfo%v700name='${ncdf_v700name}',"               >>${namelist}
echo "      netcdfinfo%z850name='${ncdf_z850name}',"               >>${namelist}
echo "      netcdfinfo%z700name='${ncdf_z700name}',"               >>${namelist}
echo "      netcdfinfo%mslpname='${ncdf_mslpname}',"               >>${namelist}
echo "      netcdfinfo%usfcname='${ncdf_usfcname}',"               >>${namelist}
echo "      netcdfinfo%vsfcname='${ncdf_vsfcname}',"               >>${namelist}
echo "      netcdfinfo%u500name='${ncdf_u500name}',"               >>${namelist}
echo "      netcdfinfo%v500name='${ncdf_v500name}',"               >>${namelist}
echo "      netcdfinfo%u200name='${ncdf_u200name}',"               >>${namelist}
echo "      netcdfinfo%v200name='${ncdf_v200name}',"               >>${namelist}
echo "      netcdfinfo%tmean_300_500_name='${ncdf_tmean_300_500_name}',"  >>${namelist}
echo "      netcdfinfo%z500name='${ncdf_z500name}',"               >>${namelist}
echo "      netcdfinfo%z200name='${ncdf_z200name}',"               >>${namelist}
echo "      netcdfinfo%lmaskname='${ncdf_lmaskname}',"             >>${namelist}
echo "      netcdfinfo%z900name='${ncdf_z900name}',"               >>${namelist}
echo "      netcdfinfo%z850name='${ncdf_z850name}',"               >>${namelist}
echo "      netcdfinfo%z800name='${ncdf_z800name}',"               >>${namelist}
echo "      netcdfinfo%z750name='${ncdf_z750name}',"               >>${namelist}
echo "      netcdfinfo%z700name='${ncdf_z700name}',"               >>${namelist}
echo "      netcdfinfo%z650name='${ncdf_z650name}',"               >>${namelist}
echo "      netcdfinfo%z600name='${ncdf_z600name}',"               >>${namelist}
echo "      netcdfinfo%z550name='${ncdf_z550name}',"               >>${namelist}
echo "      netcdfinfo%z500name='${ncdf_z500name}',"               >>${namelist}
echo "      netcdfinfo%z450name='${ncdf_z450name}',"               >>${namelist}
echo "      netcdfinfo%z400name='${ncdf_z400name}',"               >>${namelist}
echo "      netcdfinfo%z350name='${ncdf_z350name}',"               >>${namelist}
echo "      netcdfinfo%z300name='${ncdf_z300name}',"               >>${namelist}
echo "      netcdfinfo%time_name='${ncdf_time_name}',"             >>${namelist}
echo "      netcdfinfo%lon_name='${ncdf_lon_name}',"               >>${namelist}
echo "      netcdfinfo%lat_name='${ncdf_lat_name}',"               >>${namelist}
echo "      netcdfinfo%time_units='${ncdf_time_units}',"           >>${namelist}
echo "      netcdfinfo%sstname='${ncdf_sstname}',"                 >>${namelist}
echo "      netcdfinfo%q850name='${ncdf_q850name}',"               >>${namelist}
echo "      netcdfinfo%rh1000name='${ncdf_rh1000name}',"           >>${namelist}
echo "      netcdfinfo%rh925name='${ncdf_rh925name}',"             >>${namelist}
echo "      netcdfinfo%rh800name='${ncdf_rh800name}',"             >>${namelist}
echo "      netcdfinfo%rh750name='${ncdf_rh750name}',"             >>${namelist}
echo "      netcdfinfo%rh700name='${ncdf_rh700name}',"             >>${namelist}
echo "      netcdfinfo%rh650name='${ncdf_rh650name}',"             >>${namelist}
echo "      netcdfinfo%rh600name='${ncdf_rh600name}',"             >>${namelist}
echo "      netcdfinfo%spfh1000name='${ncdf_spfh1000name}',"       >>${namelist}
echo "      netcdfinfo%spfh925name='${ncdf_spfh925name}',"         >>${namelist}
echo "      netcdfinfo%spfh800name='${ncdf_spfh800name}',"         >>${namelist}
echo "      netcdfinfo%spfh750name='${ncdf_spfh750name}',"         >>${namelist}
echo "      netcdfinfo%spfh700name='${ncdf_spfh700name}',"         >>${namelist}
echo "      netcdfinfo%spfh650name='${ncdf_spfh650name}',"         >>${namelist}
echo "      netcdfinfo%spfh600name='${ncdf_spfh600name}',"         >>${namelist}
echo "      netcdfinfo%temp1000name='${ncdf_temp1000name}',"       >>${namelist}
echo "      netcdfinfo%temp925name='${ncdf_temp925name}',"         >>${namelist}
echo "      netcdfinfo%temp800name='${ncdf_temp800name}',"         >>${namelist}
echo "      netcdfinfo%temp750name='${ncdf_temp750name}',"         >>${namelist}
echo "      netcdfinfo%temp700name='${ncdf_temp700name}',"         >>${namelist}
echo "      netcdfinfo%temp650name='${ncdf_temp650name}',"         >>${namelist}
echo "      netcdfinfo%temp600name='${ncdf_temp600name}',"         >>${namelist}
echo "      netcdfinfo%omega500name='${ncdf_omega500name}'/"       >>${namelist}
echo "&parmpreflist user_wants_to_track_zeta850='${user_wants_to_track_zeta850}'," >>${namelist}
echo "      user_wants_to_track_zeta700='${user_wants_to_track_zeta700}',"         >>${namelist}
echo "      user_wants_to_track_wcirc850='${user_wants_to_track_wcirc850}',"       >>${namelist}
echo "      user_wants_to_track_wcirc700='${user_wants_to_track_wcirc700}',"       >>${namelist}
echo "      user_wants_to_track_gph850='${user_wants_to_track_gph850}',"           >>${namelist}
echo "      user_wants_to_track_gph700='${user_wants_to_track_gph700}',"           >>${namelist}
echo "      user_wants_to_track_mslp='${user_wants_to_track_mslp}',"               >>${namelist}
echo "      user_wants_to_track_wcircsfc='${user_wants_to_track_wcircsfc}',"       >>${namelist}
echo "      user_wants_to_track_zetasfc='${user_wants_to_track_zetasfc}',"         >>${namelist}
echo "      user_wants_to_track_thick500850='${user_wants_to_track_thick500850}'," >>${namelist}
echo "      user_wants_to_track_thick200500='${user_wants_to_track_thick200500}'," >>${namelist}
echo "      user_wants_to_track_thick200850='${user_wants_to_track_thick200850}'/" >>${namelist}
echo "&verbose verb=3,verb_g2=0/"                                      >>${namelist}
echo "&sheardiaginfo shearflag='${shear_calc_flag}'/"                  >>${namelist}
echo "&sstdiaginfo sstflag='${sstflag}'/"                              >>${namelist}
echo "&gendiaginfo genflag='${genflag}',"                              >>${namelist}
echo "             gen_read_rh_fields='${gen_read_rh_fields}',"        >>${namelist}
echo "             need_to_compute_rh_from_q='${need_to_compute_rh_from_q}',"  >>${namelist}
echo "             smoothe_mslp_for_gen_scan='${smoothe_mslp_for_gen_scan}'/"  >>${namelist}

##########################################################################
# Now link various files that are either needed as input to the tracker,
# or are output from the tracker.  Note that the namelist file is linked
# to a fortran unit, instead of using the standard way of redirect on the
# the command line (e.g., gettrk.exe < namelist_file).  The reason for 
# this is that someone from NCEP told me that they encountered an issue 
# on one of the platforms running the tracker where the operating system
# balked at the use of the redirect.  So, to make things easy, the
# namelist is just fortran-unit-linked to unit 555 now.
#
# With the exception of unit 555 for the namelist, all unit numbers < 50
# are for input, and all unit numbers > 50 are for output.
##########################################################################

cp ${namelist} namelist.gettrk
ln -s -f namelist.gettrk                                             fort.555

if [ ${inp_data_type} = 'grib' ]; then
  ln -s -f ${gribfile}                                               fort.11
else
  ln -s -f ${netcdffile}                                             fort.11
  if [ ${read_separate_land_mask_file} = 'y' ]; then
    ln -s -f ${ncdf_ls_mask_filename}                                fort.17
  fi
fi

# ln -s -f ${DATA}/vitals.upd.${atcfout}.${PDY}${shh}                fort.12
# ln -s -f ${DATA}/genvitals.upd.${cmodel}.${atcfout}.${PDY}${CYL}   fort.14

if [ -s ${wdir}/vitals.${curymdh} ]; then
  cp ${wdir}/vitals.${curymdh} \
     ${DATA}/tcvit_rsmc_storms.txt
else
  >${DATA}/tcvit_rsmc_storms.txt
fi

if [ -s ${DATA}/genvitals.upd.${atcfout}.${PDY}${shh} ]; then
  cp ${DATA}/genvitals.upd.${atcfout}.${PDY}${shh} \
     ${DATA}/tcvit_genesis_storms.txt
else
  >${DATA}/tcvit_genesis_storms.txt
fi

ln -s -f ${rundir}/${cmodel}.tracker_leadtimes                       fort.15

if [ ${inp_data_type} = 'grib' ]; then
  ln -s -f ${ixfile}                                                 fort.31
fi

if [ ${trkrtype} = 'tracker' ]; then
  ln -s -f ${DATA}/trak.${atcfout}.all.${PDY}${CYL}          fort.61
  ln -s -f ${DATA}/trak.${atcfout}.atcf.${PDY}${CYL}         fort.62
  ln -s -f ${DATA}/trak.${atcfout}.radii.${PDY}${CYL}        fort.63
  ln -s -f ${DATA}/trak.${atcfout}.atcfunix.${PDY}${CYL}     fort.64
  ln -s -f ${DATA}/trak.${atcfout}.atcf_gen.${PDY}${CYL}     fort.66
  ln -s -f ${DATA}/trak.${atcfout}.atcfunix_ext.${PDY}${CYL} fort.68
  ln -s -f ${DATA}/trak.${atcfout}.atcf_hfip.${PDY}${CYL}    fort.69
  ln -s -f ${DATA}/trak.${atcfout}.parmfix.${PDY}${CYL}      fort.81
else
  ln -s -f ${DATA}/trak.${atcfout}.all.${regtype}.${PDY}${CYL}          fort.61
  ln -s -f ${DATA}/trak.${atcfout}.atcf.${regtype}.${PDY}${CYL}         fort.62
  ln -s -f ${DATA}/trak.${atcfout}.radii.${regtype}.${PDY}${CYL}        fort.63
  ln -s -f ${DATA}/trak.${atcfout}.atcfunix.${regtype}.${PDY}${CYL}     fort.64
  ln -s -f ${DATA}/trak.${atcfout}.atcf_gen.${regtype}.${PDY}${CYL}     fort.66
  ln -s -f ${DATA}/trak.${atcfout}.atcfunix_ext.${regtype}.${PDY}${CYL} fort.68
  ln -s -f ${DATA}/trak.${atcfout}.atcf_hfip.${regtype}.${PDY}${CYL}    fort.69
  ln -s -f ${DATA}/trak.${atcfout}.parmfix.${regtype}.${PDY}${CYL}      fort.81
fi

if [ ${atcfname} = 'aear' ]
then
  ln -s -f ${DATA}/trak.${atcfout}.initvitl.${PDY}${CYL}           fort.65
fi

if [ ${write_vit} = 'y' ]
then
  ln -s -f ${DATA}/output_genvitals.${atcfout}.${PDY}${shh}        fort.67
fi

if [ ${PHASEFLAG} = 'y' ]; then
  ln -s -f ${DATA}/trak.${atcfout}.cps_parms.${PDY}${CYL}          fort.71
fi

if [ ${STRUCTFLAG} = 'y' ]; then
  ln -s -f ${DATA}/trak.${atcfout}.structure.${regtype}.${PDY}${CYL}          fort.72
  ln -s -f ${DATA}/trak.${atcfout}.fractwind.${regtype}.${PDY}${CYL}          fort.73
  ln -s -f ${DATA}/trak.${atcfout}.pdfwind.${regtype}.${PDY}${CYL}            fort.76
fi

if [ ${IKEFLAG} = 'y' ]; then
  ln -s -f ${DATA}/trak.${atcfout}.ike.${regtype}.${PDY}${CYL}                fort.74
fi

if [ ${trkrtype} = 'midlat' -o ${trkrtype} = 'tcgen' -o ${trkrtype} = 'tracker' ]; then
  ln -s -f ${DATA}/trkrmask.${atcfout}.${regtype}.${PDY}${CYL}     fort.77
fi

########################################################################
# Now run the tracker....
########################################################################

set +x
echo " "
echo " -----------------------------------------------"
echo "           NOW EXECUTING TRACKER......"
echo " -----------------------------------------------"
echo " "
set -x

echo "gettrk start for $atcfout at ${CYL}z at `date`"

set +x
echo "+++ TIMING: BEFORE gettrk  ---> `date`"
set -x

export FOR_DUMP_CORE_FILE=TRUE
ulimit -s unlimited

echo " "
echo "before gettrk, Output of ulimit command follows...."
ulimit -a
echo "before gettrk, Done: Output of ulimit command."

/home/Caitlyn.Mcallister/findvariables/code/exec/gettrk.x <${namelist}
gettrk_rcc=$?

set +x
echo "+++ TIMING: AFTER  gettrk  ---> `date`"
echo "   "
echo "   Return code from tracker= gettrk_rcc= ${gettrk_rcc}"
echo "   "
set -x
