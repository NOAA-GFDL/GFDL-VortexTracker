#!/bin/bash

# ------------------------------------------------------------------------------
# function to display a spinning wheel while a command is in progress
spin()
{
  spinner="\\|/-\\|/-"
  while :
  do
    for i in `seq 0 7`
    do
      echo -n "${spinner:$i:1}"
      echo -en "\010"
      sleep 1
    done
  done
}
# end function
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# DECLARE DEFAULT VARIABLES & PATHS

# declare default arguments
system=""					# system being used
compiler="intel"	# compiler
clean="fresh" 		# cleaning mode
mode="prod" 			# build mode

export rootdir=${PWD%/*}
export rundir=${rootdir}/run
export workdir=${rundir}/work
export compdir=${rootdir}/compile
export codedir=${compdir}/src_code
export execdir=${codedir}/exec
export builddir=${codedir}/build
export logdir=${workdir}/logfiles
export date_stamp=$(date +"%a %b %d %H:%M:%S %Z %Y")
export today_stamp=$(date +"%m.%d-%H.%M%p")
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# PARSE ARGS
for arg in "$@"
do
  case $arg in
    #system
    ppan|gaea|hera|hercules|orion|ursa|wcoss2|container|personal)
    	system="${arg#*=}"
    	# if-statements go here if needed
			shift # remove "system" from processing
      ;;
    #compiler
		intel|gcc)
			compiler="${arg#*=}"
			shift # remove "compiler" from proccessing
			;;
  	#clean
		fresh|clean)
			clean="${arg#*=}"
			shift # remove "clean" from processing
			;;
		#mode
		prod|debug)
			mode="${arg#*=}"
			shift # remove "mode" from processing
			;;
	#verbose
  	# catch
    *)
    	if [ ${arg#} != '--help' ] && [ ${arg#} != '-h' ] ; then
        echo -e "** INVALID ARGUMENT ** \t--> "${arg#}" "
      fi
			echo -e " "
			echo -e "Example command --> ./compiletrkr <system> [compiler] [mode] [clean]"
			echo -e "(arguments inside brackets are optional, defaults are listed below)"
			echo -e " "
			echo -e "Valid options for system configuration are: "
			echo -e "\t[ gaea | hera | hercules | orion | ppan | ursa | wcoss2 | container | personal ] "
      echo -e "Valid options for compilers are: "
			echo -e "\t[ intel(D) | gcc ] "
      echo -e "Valid options compilations modes are: "
			echo -e "\t[ prod(D) | debug ] "
			echo -e "Valid cleaning options are: " 
			echo -e "\t[ fresh(D) | clean ] "
			echo -e " "
			echo -e "Documentation and additional instructions can be found here: "
			echo -e "\t<add link here when ready>"
			echo -e " "
			echo -e "If a you are experiencing other complications please open an issue via GitHub"
			echo -e "Issues can be created here: https://github.com/NOAA-GFDL/GFDL-VortexTracker/issues/new"
			echo -e " "
      exit
      ;;
  esac
done

# 'system' cannot be empty when script is run
if [ -z "${system}" ]; then
	echo -e " "
	echo -e "\t** MISSING SYSTEM ARGUMENT **"
	echo -e "System arg required for compilation to continue"
	echo -e "For more info run: "
	echo -e "\t./compiletrkr.sh --help"
	echo -e " "
	exit 0
fi

# no gcc environment available on gaea or wcoss2
if [[ (${system} == "gaea" || ${system} == "wcoss2") && ${compiler} = "gcc" ]]; then
  echo -e "There is currently no ${compiler} environment available on ${system}"
  echo -e "Please try using different compiler"
  echo -e "\n"
  exit 1
fi
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# START SCRIPT, CREATE STDOUT FILE, SAVE COMPILE VARS

spin &
SPIN_PID=$!
trap "kill -9 $SPIN_PID" `seq 0 15`

if [ ! -d ${logdir} ]; then mkdir -p ${logdir}; fi
export logfile="${logdir}/build_${compiler}_${system}_${today_stamp}.log"
exec > >(tee -a "${logfile}") 2>&1

export tmpdir=${workdir}/tmpfiles
if [ ! -d ${tmpdir} ]; then mkdir -p ${tmpdir}; fi
export compileinputs=${tmpdir}/compileinputs.txt

cat << EOF > ${compileinputs}
rootdir='${PWD%/*}'
rundir='${rootdir}/run'
workdir='${rundir}/work'
compdir='${rootdir}/compile'
codedir='${compdir}/src_code'
execdir='${codedir}/exec'
builddir='${codedir}/build'
logdir='${codedir}/logfiles'
system='${system}'
compiler='${compiler}'
clean='${clean}'
mode='${mode}'
EOF

# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# LOAD ENVIRONMENT

echo -e "Loading environment for ${system} with ${compiler} compiler"
sleep 2

# load modules 
. ${compdir}/system-envs/${compiler}/${system}.sh

# list modules
echo -e " "
module list
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# PRINT BEFORE COMPILATION

# output build setup
echo -e " "
echo -e "Compilation initiated with the following: "
echo -e "\tsystem   = ${system}"
echo -e "\tcompiler = ${compiler}"
echo -e "\tclean    = ${clean}"
echo -e "\tmode     = ${mode}"
echo -e "\n"
sleep 3

# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# INITIATE CMAKE SYSTEM

echo -e " "
echo -e "Creating executables on ${system} with ${compiler} on ${date_stamp}"
sleep 3

if [ -d ${builddir} ]; then

	if [ ${clean} = "fresh" ]; then
		echo -e "\tpreexisting build directory found; removing contents and continuing compilation"
		echo -e "\n"
		sleep 2
		rm -rf ${builddir}/*
		cd ${builddir} ; cmake .. ; make ;
	elif [ ${clean} = "clean" ]; then
		echo -e "\tcleaning build directory then recompiling"
		echo -e "\n"
		sleep 2
		cd ${builddir}; cmake --build . --clean-first ;
	fi
	
elif [ ! -d ${builddir} ]; then
	if [ ${clean} = "clean" ]; then
		echo -e "\tno preexisting code to clean;"
	fi
	echo -e "\tgenerating new build directory & initiating compilation"
	echo -e "\n"
	sleep 2
	mkdir ${builddir}
	cd ${builddir} ; cmake .. ; make ;
fi

# report on compilation 
if [ $? -ne 0 ] ; then
	echo -e " "
 	echo -e "\tERROR with compilation"
	echo -e "\n"
 	exit 1
else
	echo -e " "
 	echo -e "\tCOMPILATION SUCCESSFUL"
	echo -e "\n"
fi

# install executables in exec/ dir
if [ -d ${execdir} ]; then rm -rf ${execdir}; fi
make install

echo -e "\n"
echo -e "A log from this compilation can be found here:"
echo -e "\t${logfile}"
echo -e "\n"
# ------------------------------------------------------------------------------

exit 0
