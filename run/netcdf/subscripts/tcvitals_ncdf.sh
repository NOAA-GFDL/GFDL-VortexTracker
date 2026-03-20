# -------------------------------------------------------------------------------------------------
# SET UP KNOWN TCVITALS FILE
set -x

if [ -z ${tcvitals_file} ]; then  # need to record tcvitals
  echo "tcvitals file not known; running tcvitals code"

  export find_vitals_data="$(grep "${yyyy}${mm}${dd} ${hh}" ${arcvitals}/syndat_tcvitals.${yyyy} | \
          sort -k2 -k4 -n -k5 -n -u | sort -k4 -n -k5 -n | egrep "JTWC|NHC"                       | \
          awk 'substr($0,6,1) !~ /8/ {print $0}' > ${wdir}/vitals.${ymdh})"

else  # tcvitals file already created; copy to work dir
  echo "tcvitals files already created; copying to work dir"
  cp ${tcvitals_file} ${wdir}/vitals.${ymdh}

fi

export num_storms="$(cat ${wdir}/vitals.${ymdh} | wc -l)"

if [ ${num_storms} -gt 0 ]; then
  echo "${num_storms} Observed storms exist for ${ymdh}: "
  cat ${wdir}/vitals.${ymdh}
else
  touch ${wdir}/vitals.${ymdh}
fi

# -------------------------------------------------------------------------------------------------
set +x