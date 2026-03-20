# -------------------------------------------------------------------------------------------------
# SET UP INPUT/OUTPUT FILES
set -x

# go into work dir to add files
cd ${wdir}

# link various files that are either needed as input to the tracker or are output from the tracker
cp ${namelist} namelist.gettrk
ln -s -f namelist.gettrk                                  fort.555

ln -s -f ${ncdf_filename}                                 fort.11
if [ ${read_separate_land_mask_file} = 'y' ]; then
  ln -s -f ${ncdf_ls_mask_filename}                       fort.17
fi

if [ -s ${wdir}/vitals.${ymdh} ]; then
  cp ${wdir}/vitals.${ymdh} ${wdir}/tcvit_rsmc_storms.txt
else
  > ${wdir}/tcvit_rsmc_storms.txt
fi

if [ -s ${wdir}/genvitals.upd.${atcfname}.${ymdh} ]; then
  cp ${wdir}/genvitals.upd.${atcfname}.${ymdh} ${wdir}/tcvit_genesis_storms.txt
else
  > ${wdir}/tcvit_genesis_storms.txt
fi

ln -s -f ${rundir}/leadtimes.txt                          fort.15

if [ ${vortex_tilt_flag} = 'y' ]; then
  ln -s -f ${rundir}/vortex_tilt_levs.txt                 fort.18
  ln -s -f ${rundir}/vortex_tilt_vars.txt                 fort.33
  ln -s -f ${wdir}/trak.${atcfname}.vortex_tilt.${ymdh}   fort.82
fi

if [ ${trkrtype} = 'tracker' ]; then
  ln -s -f ${wdir}/trak.${atcfname}.all.${ymdh}           fort.61
  ln -s -f ${wdir}/trak.${atcfname}.atcf.${ymdh}          fort.62
  ln -s -f ${wdir}/trak.${atcfname}.atcfunix.${ymdh}      fort.64
  ln -s -f ${wdir}/trak.${atcfname}.atcfunix_ext.${ymdh}  fort.68
  ln -s -f ${wdir}/trak.${atcfname}.atcf_hfip.${ymdh}     fort.69
  ln -s -f ${wdir}/trak.${atcfname}.parmfix.${ymdh}       fort.81
else  # trkrtype = tcgen
  ln -s -f ${wdir}/trak.${atcfname}.all.${ymdh}           fort.61
  ln -s -f ${wdir}/trak.${atcfname}.atcf.${ymdh}          fort.62
  ln -s -f ${wdir}/trak.${atcfname}.atcfunix.${ymdh}      fort.64
  ln -s -f ${wdir}/trak.${atcfname}.atcf_gen.${ymdh}      fort.66
  ln -s -f ${wdir}/trak.${atcfname}.atcfunix_ext.${ymdh}  fort.68
  ln -s -f ${wdir}/trak.${atcfname}.atcf_hfip.${ymdh}     fort.69
  ln -s -f ${wdir}/trak.${atcfname}.parmfix.${ymdh}       fort.81
fi

if [ ${write_vit} = 'y' ]
then
  ln -s -f ${wdir}/output_genvitals.${atcfname}.${ymdh}   fort.67
fi

if [ ${phaseflag} = 'y' ]; then
  ln -s -f ${wdir}/trak.${atcfname}.cps_parms.${ymdh}     fort.71
fi

if [ ${structflag} = 'y' ]; then
  ln -s -f ${wdir}/trak.${atcfname}.structure.${ymdh}     fort.72
  ln -s -f ${wdir}/trak.${atcfname}.fractwind.${ymdh}     fort.73
  ln -s -f ${wdir}/trak.${atcfname}.pdfwind.${ymdh}       fort.76
fi

if [ ${ikeflag} = 'y' ]; then
  ln -s -f ${wdir}/trak.${atcfname}.ike.${ymdh}           fort.74
fi

if [ ${trkrtype} = 'midlat' -o ${trkrtype} = 'tcgen' -o ${trkrtype} = 'tracker' ]; then
  ln -s -f ${wdir}/trkrmask.${atcfname}.${ymdh}           fort.77
fi

# -------------------------------------------------------------------------------------------------
set +x