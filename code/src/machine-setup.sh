# this script defines a target variable that is equivalent to which rdhpc system user is on
# it does this be indexing through an array with each login-node for the different systems
# this is used so that the correct set of modules is loaded for each individual rdhpc system

# declare target variable (i.e. which system user is on)
target=""
echo $HOSTNAME

# create arrays with elements of every known login-node for each system
analysis=("an001" "an002" "an007" "an008" "an009" "an010" "an011" "an012" "an014" \
          "an101" "an102" "an103" "an104" "an105" "an106" "an107" "an108" "an200" \
          "an201" "an202" "an203" "an204" "an205" "an206" "an207" "an210")

gaea=("gaea" \
      "gaea51" "gaea52" "gaea53" "gaea54" "gaea55" "gaea56" "gaea57" "gaea58" \
      "gaea60" "gaea61" "gaea62" "gaea63" "gaea64" "gaea65" "gaea66" "gaea67" "gaea68")	

jet=("ecflow1" "fe1" "fe2" "fe3" "fe4" "fe5" "fe6" "fe7" "fe8" "tfe1" "tfe2")

hera=("hecflow01" "hera" "hfe01" "hfe02" "hfe03" "hfe04" "hfe05" "hfe06" "hfe07" "hfe08" "hfe09" "hfe10" "hfe11")

orion=("orion-login-1.hpc.msstate.edu" "orion-login-2.hpc.msstate.edu" \
       "orion-login-3.hpc.msstate.edu" "orion-login-4.hpc.msstate.edu")

hercules=("hercules-login-1.hpc.msstate.edu" "hercules-login-2.hpc.msstate.edu" \
          "hercules-login-3.hpc.msstate.edu" "hercules-login-4.hpc.msstate.edu")

#wcoss2= this will have to be done when I have access to wcoss2

# loop through each system array for a matching login-node to set target = to the correct machine
for i in "${!analysis[@]}"; do
  if [ "${analysis[$i]}" == $HOSTNAME ]; then
    source $MODULESHOME/init/bash
    target=analysis
    echo $target
  fi
done

for i in "${!gaea[@]}"; do
  if [ "${gaea[$i]}" == $HOSTNAME ]; then
    source $MODULESHOME/init/bash
    target=gaea
    echo $target
  fi
done

for i in "${!jet[@]}"; do
  if [ "${jet[$i]}" == $HOSTNAME ]; then
    source $MODULESHOME/init/bash
    target=jet
    echo $target
  fi
done

for i in "${!hera[@]}"; do
  if [ "${hera[$i]}" == $HOSTNAME ]; then
    source $MODULESHOME/init/bash
    target=hera
    echo $target
  fi
done

for i in "${!orion[@]}"; do
  if [ "${orion[$i]}" == $HOSTNAME ]; then
    source $MODULESHOME/init/bash
    target=orion
    echo $target
  fi
done

for i in "${!hercules[@]}"; do
  if [ "${hercules[$i]}" == $HOSTNAME ]; then
    source $MODULESHOME/init/bash
    target=hercules
    echo $target
  fi
done
