
target=""
USERNAME=`echo $LOGNAME | awk '{ print tolower($0)'}`

if [[ -d /lfs4 ]] ; then
    # We are on NOAA Jet
    if ( ! eval module help > /dev/null 2>&1 ) ; then
        echo load the module command 1>&2
        source /apps/lmod/lmod/init/
    fi
    target=jet
    module purge

elif [[ -d /scratch1/NCEPDEV ]] ; then
    # We are on NOAA Hera
    if ( ! eval module help > /dev/null 2>&1 ) ; then
        echo load the module command 1>&2
        source /apps/lmod/lmod/init/$__ms_shell
    fi
    target=hera
    module purge

elif [[ -d /work/noaa ]] ; then
    # We are on MSU Orion
    if ( ! eval module help > /dev/null 2>&1 ) ; then
	echo load the module command 1>&2
        source /apps/lmod/lmod/init/$__ms_shell
    fi
    target=orion
    module purge
    module use /apps/modulefiles/core
    module use /apps/contrib/modulefiles
    module use /apps/contrib/NCEPLIBS/lib/modulefiles
    module use /apps/contrib/NCEPLIBS/orion/modulefiles

elif [[ -d /gpfs/hps && -e /etc/SuSE-release ]] ; then
    # We are on wcoss_cray
    if ( ! eval module help > /dev/null 2>&1 ) ; then
        echo load the module command 1>&2
        source /opt/modules/default/init/$__ms_shell
    fi
    target=wcoss_cray

    # Silence the "module purge" to avoid the expected error messages
    # related to modules that load modules.
    module purge > /dev/null 2>&1
    module use /usrx/local/prod/modulefiles
    module use /gpfs/hps/nco/ops/nwprod/lib/modulefiles
    module use /gpfs/hps/nco/ops/nwprod/modulefiles
    module use /opt/cray/alt-modulefiles
    module use /opt/cray/craype/default/alt-modulefiles
    module use /opt/cray/ari/modulefiles
    module use /opt/modulefiles
    module purge > /dev/null 2>&1

    # Workaround until module issues are fixed:
    unset _LMFILES_
    unset LOADEDMODULES
    echo y 2> /dev/null | module clear > /dev/null 2>&1

    module use /usrx/local/prod/modulefiles
    module use /gpfs/hps/nco/ops/nwprod/lib/modulefiles
    module use /gpfs/hps/nco/ops/nwprod/modulefiles
    module use /opt/cray/alt-modulefiles
    module use /opt/cray/craype/default/alt-modulefiles
    module use /opt/cray/ari/modulefiles
    module use /opt/modulefiles
    module load modules

elif [[ -d /lfs/h1 && -d /lfs/h2 ]] ; then
    target=wcoss2
    . $MODULESHOME/init/sh

elif [[ -d /ncrc && -d /gpfs/f5 ]] ; then
    # We are on GAEA.
    if ( ! eval module help > /dev/null 2>&1 ) ; then
        source $MODULESHOME/init/bash
	echo load the module command 1>&2
    fi
    target=gaea

elif [[ -d /home/$USER && -d /work/$USER ]] ; then
    target="ppan"

else
    echo WARNING: UNKNOWN PLATFORM 1>&2
fi