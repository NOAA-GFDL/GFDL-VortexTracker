
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
        source /apps/lmod/lmod/init/
    fi
    target=hera
    module purge

elif [[ -d /work/noaa && -d /home/$USER ]] ; then
    # We are on MSU Orion
    source $MODULESHOME/init/bash
    target=orion

elif [[ -d /work/noaa && -d /home/$USER ]] ; then
    # We are on MSU Hercules
    source $MODULESHOME/init/bash
    target=hercules

elif [[ -d /lfs/h1 && -d /lfs/h2 ]] ; then
    target=wcoss2
    source $MODULESHOME/init/sh

elif [[ -d /ncrc && -d /gpfs/f5 ]] ; then
    # We are on GAEA.
    if ( ! eval module help > /dev/null 2>&1 ) ; then
        source $MODULESHOME/init/bash
	echo load the module command 1>&2
    fi
    target=gaea

elif [[ -d /home/$USER && -d /work/$USER ]] ; then
    source $MODULESHOME/init/bash
    target="ppan"

else
    echo WARNING: UNKNOWN PLATFORM 1>&2
fi
