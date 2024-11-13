# this script defines a target variable that is equivalent to which rdhpc system user is on
# it does this be indexing through an array with each login-node for the different systems

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
