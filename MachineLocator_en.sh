#!/bin/bash

# Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

function ctrl_c(){
  echo -e "\n${redColour}[!] Saliendo del programa...${endColour}\n"
  tput cnorm && exit 1
}

# CTRL + C to STOP the program
trap ctrl_c INT

# General global variables
htbMachines="https://docs.google.com/spreadsheets/d/1dzvaGlT_0xnT-PGO27Z_4prHgA8PHIpErmoWdlUrSoA/export?format=tsv&id=1dzvaGlT_0xnT-PGO27Z_4prHgA8PHIpErmoWdlUrSoA&gid=0"
htbName="export?format=tsv&id=1dzvaGlT_0xnT-PGO27Z_4prHgA8PHIpErmoWdlUrSoA&gid=0"
vulhubMachines="https://docs.google.com/spreadsheets/d/1dzvaGlT_0xnT-PGO27Z_4prHgA8PHIpErmoWdlUrSoA/export?format=tsv&id=1dzvaGlT_0xnT-PGO27Z_4prHgA8PHIpErmoWdlUrSoA&gid=810933541"
vulhubName="export?format=tsv&id=1dzvaGlT_0xnT-PGO27Z_4prHgA8PHIpErmoWdlUrSoA&gid=810933541"
otherMachines="https://docs.google.com/spreadsheets/d/1dzvaGlT_0xnT-PGO27Z_4prHgA8PHIpErmoWdlUrSoA/export?format=tsv&id=1dzvaGlT_0xnT-PGO27Z_4prHgA8PHIpErmoWdlUrSoA&gid=1684487917"
otherName="export?format=tsv&id=1dzvaGlT_0xnT-PGO27Z_4prHgA8PHIpErmoWdlUrSoA&gid=1684487917"

Platform1="HackTheBox"
Platform2="VulnHub"
Platform3="Other"

# Global variables for better optimization in the code
fileName="$(echo "$0")"
DifficultieColour=""
AllDifficulties="\t"

machinesSkillName=""

platform1="$(echo "$Platform1" | tr '[:upper:]' '[:lower:]')"
platform2="$(echo "$Platform2" | tr '[:upper:]' '[:lower:]')"
platform3="$(echo "$Platform3" | tr '[:upper:]' '[:lower:]')"
check=0

htbInfo=""
vulhubInfo=""
otherInfo=""

htbFilter=""
vulhubFilter=""
otherFilter=""

ONE=""

# Functions

# Show all options of parameters that can be use 
function helpPanel(){
  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Uso:${endColour}\n"
  echo -e "\t${blueColour}u)${endColour} ${grayColour}Download or update required files.${endColour}"
  echo -e "\t${blueColour}m)${endColour} ${grayColour}Search machine by name.${endColour}"
  echo -e "\t${blueColour}i)${endColour} ${grayColour}Search machine by IP.${endColour}"
  echo -e "\t${blueColour}o)${endColour} ${grayColour}Search machine by operative system.${endColour}"
  echo -e "\t${blueColour}d)${endColour} ${grayColour}Search machine by difficulty.${endColour}"
  echo -e "\t${blueColour}s)${endColour} ${grayColour}Search machine by skill.${endColour}"
  echo -e "\t${blueColour}c)${endColour} ${grayColour}Search machine by certification (Like).${endColour}"
  echo -e "\t${blueColour}y)${endColour} ${grayColour}Get youtube link where the machine is solve (writeup).${endColour}"
  echo -e "\t${blueColour}p)${endColour} ${grayColour}Get machines by Platform.${endColour}"
  echo -e "\t${blueColour}h)${endColour} ${grayColour}Show help panel.${endColour}"

  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Show possible combinations:${endColour}\n"
  echo -e "\t${blueColour}k)${endColour} ${grayColour}Show combinations between parameters.${endColour}"
  echo -e "\t${blueColour}l)${endColour} ${grayColour}Show combinations for parameter -p.${endColour}"
  echo ""
}

# Show all possible combinations with the parameter P
function showParameterP(){
  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Possible combinations with parameter${endColour} ${blueColour}-p${enndColour}${grayColour}:${endColour}\n"
  echo -e "\t${greenColour}${fileName}${endColour} ${blueColour}-p${endColour} ${yellowColour}\"\"${endColour} ${purpleColour}-m${endColour} ${yellowColour}\"\"${endColour}"
  echo -e "\t${greenColour}${fileName}${endColour} ${blueColour}-p${endColour} ${yellowColour}\"\"${endColour} ${purpleColour}-o${endColour} ${yellowColour}\"\"${endColour}"
  echo -e "\t${greenColour}${fileName}${endColour} ${blueColour}-p${endColour} ${yellowColour}\"\"${endColour} ${purpleColour}-d${endColour} ${yellowColour}\"\"${endColour}"
  echo -e "\t${greenColour}${fileName}${endColour} ${blueColour}-p${endColour} ${yellowColour}\"\"${endColour} ${purpleColour}-s${endColour} ${yellowColour}\"\"${endColour}"
  echo -e "\t${greenColour}${fileName}${endColour} ${blueColour}-p${endColour} ${yellowColour}\"\"${endColour} ${purpleColour}-c${endColour} ${yellowColour}\"\"${endColour}\n"
  echo -e "\t${greenColour}${fileName}${endColour} ${blueColour}-p${endColour} ${yellowColour}\"\"${endColour} ${purpleColour}-d${endColour} ${yellowColour}\"\"${endColour} ${purpleColour}-s${endColour} ${yellowColour}\"\"${endColour}"
  echo -e "\t${greenColour}${fileName}${endColour} ${blueColour}-p${endColour} ${yellowColour}\"\"${endColour} ${purpleColour}-d${endColour} ${yellowColour}\"\"${endColour} ${purpleColour}-c${endColour} ${yellowColour}\"\"${endColour}"
  echo -e "\t${greenColour}${fileName}${endColour} ${blueColour}-p${endColour} ${yellowColour}\"\"${endColour} ${purpleColour}-d${endColour} ${yellowColour}\"\"${endColour} ${purpleColour}-o${endColour} ${yellowColour}\"\"${endColour}"
  echo -e "\t${greenColour}${fileName}${endColour} ${blueColour}-p${endColour} ${yellowColour}\"\"${endColour} ${purpleColour}-s${endColour} ${yellowColour}\"\"${endColour} ${purpleColour}-c${endColour} ${yellowColour}\"\"${endColour}"
  echo -e "\t${greenColour}${fileName}${endColour} ${blueColour}-p${endColour} ${yellowColour}\"\"${endColour} ${purpleColour}-o${endColour} ${yellowColour}\"\"${endColour} ${purpleColour}-s${endColour} ${yellowColour}\"\"${endColour}"
  echo -e "\t${greenColour}${fileName}${endColour} ${blueColour}-p${endColour} ${yellowColour}\"\"${endColour} ${purpleColour}-o${endColour} ${yellowColour}\"\"${endColour} ${purpleColour}-c${endColour} ${yellowColour}\"\"${endColour}\n"
  echo -e "\t${greenColour}${fileName}${endColour} ${blueColour}-p${endColour} ${yellowColour}\"\"${endColour} ${purpleColour}-o${endColour} ${yellowColour}\"\"${endColour} ${purpleColour}-d${endColour} ${yellowColour}\"\"${endColour} ${purpleColour}-s${endColour} ${yellowColour}\"\"${endColour}"
  echo -e "\t${greenColour}${fileName}${endColour} ${blueColour}-p${endColour} ${yellowColour}\"\"${endColour} ${purpleColour}-o${endColour} ${yellowColour}\"\"${endColour} ${purpleColour}-d${endColour} ${yellowColour}\"\"${endColour} ${purpleColour}-c${endColour} ${yellowColour}\"\"${endColour}"
  echo -e "\t${greenColour}${fileName}${endColour} ${blueColour}-p${endColour} ${yellowColour}\"\"${endColour} ${purpleColour}-o${endColour} ${yellowColour}\"\"${endColour} ${purpleColour}-s${endColour} ${yellowColour}\"\"${endColour} ${purpleColour}-c${endColour} ${yellowColour}\"\"${endColour}"
  echo -e "\t${greenColour}${fileName}${endColour} ${blueColour}-p${endColour} ${yellowColour}\"\"${endColour} ${purpleColour}-d${endColour} ${yellowColour}\"\"${endColour} ${purpleColour}-s${endColour} ${yellowColour}\"\"${endColour} ${purpleColour}-c${endColour} ${yellowColour}\"\"${endColour}\n"
}

# Show all possible combinations between parameters
function showCombinations(){
  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Possible combinations between parameters:${endColour}\n"
  echo -e "\t${greenColour}${fileName}${endColour} ${purpleColour}-d${endColour} ${yellowColour}\"\"${endColour} ${purpleColour}-s${endColour} ${yellowColour}\"\"${endColour}"
  echo -e "\t${greenColour}${fileName}${endColour} ${purpleColour}-d${endColour} ${yellowColour}\"\"${endColour} ${purpleColour}-c${endColour} ${yellowColour}\"\"${endColour}"
  echo -e "\t${greenColour}${fileName}${endColour} ${purpleColour}-d${endColour} ${yellowColour}\"\"${endColour} ${purpleColour}-o${endColour} ${yellowColour}\"\"${endColour}"
  echo -e "\t${greenColour}${fileName}${endColour} ${purpleColour}-s${endColour} ${yellowColour}\"\"${endColour} ${purpleColour}-c${endColour} ${yellowColour}\"\"${endColour}"
  echo -e "\t${greenColour}${fileName}${endColour} ${purpleColour}-o${endColour} ${yellowColour}\"\"${endColour} ${purpleColour}-s${endColour} ${yellowColour}\"\"${endColour}"
  echo -e "\t${greenColour}${fileName}${endColour} ${purpleColour}-o${endColour} ${yellowColour}\"\"${endColour} ${purpleColour}-c${endColour} ${yellowColour}\"\"${endColour}\n"
  echo -e "\t${greenColour}${fileName}${endColour} ${purpleColour}-o${endColour} ${yellowColour}\"\"${endColour} ${purpleColour}-d${endColour} ${yellowColour}\"\"${endColour} ${purpleColour}-s${endColour} ${yellowColour}\"\"${endColour}"
  echo -e "\t${greenColour}${fileName}${endColour} ${purpleColour}-o${endColour} ${yellowColour}\"\"${endColour} ${purpleColour}-d${endColour} ${yellowColour}\"\"${endColour} ${purpleColour}-c${endColour} ${yellowColour}\"\"${endColour}"
  echo -e "\t${greenColour}${fileName}${endColour} ${purpleColour}-o${endColour} ${yellowColour}\"\"${endColour} ${purpleColour}-s${endColour} ${yellowColour}\"\"${endColour} ${purpleColour}-c${endColour} ${yellowColour}\"\"${endColour}"
  echo -e "\t${greenColour}${fileName}${endColour} ${purpleColour}-d${endColour} ${yellowColour}\"\"${endColour} ${purpleColour}-s${endColour} ${yellowColour}\"\"${endColour} ${purpleColour}-c${endColour} ${yellowColour}\"\"${endColour}\n"
}

# Download the required files for the program works
function downloadFiles(){
  (wget "$htbMachines") &> /dev/null
  (wget "$vulhubMachines") &> /dev/null
  (wget "$otherMachines") &> /dev/null
  mv "$htbName" "htbMachines.tsv" &> /dev/null
  if [ "$(echo "$?")" != "0" ]; then
    echo -e "\n${redColour}[!] Error to download required files, try again.${endColour}\n"
    rm -f "$htbName" &> /dev/null
    exit 1
  else
    cat htbMachines.tsv | tail -n +4 | sponge htbMachines.tsv
  fi

  mv "$vulhubName" "vulhubMachines.tsv" &> /dev/null
  if [ "$(echo "$?")" != "0" ]; then
    echo -e "\n${redColour}[!] Error to download required files, try again.${endColour}\n"
    rm -f "$htbName" &> /dev/null
    rm -f "htbMachines.tsv" &> /dev/null
    rm -f "$vulhubName" &> /dev/null
    exit 1
  else
    cat vulhubMachines.tsv | tail -n +2 | sponge vulhubMachines.tsv
  fi

  mv "$otherName" "otherMachines.tsv" &> /dev/null
  if [ "$(echo "$?")" != "0" ]; then
    echo -e "\n${redColour}[!] Error to download required files, try again.${endColour}\n"
    rm -f "$htbName" &> /dev/null
    rm -f "htbMachines.tsv" &> /dev/null
    rm -f "$vulhubName" &> /dev/null
    rm -f "vulhubMachines.tsv" &> /dev/null
    rm -f "$otherName" &> /dev/nullhtbOS
    exit 1
  else
    cat otherMachines.tsv | tail -n +3 | sponge otherMachines.tsv
  fi
}

# Check if already exist the required files and then update or download it
function updateFiles(){
  # ocultando el cursor
  tput civis

  if [ ! -f htbMachines.tsv ] && [ ! -f vulhubMachines.tsv  ] && [ ! -f otherMachines.tsv ] ; then
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Downloading required files...${endColour}\n"
    downloadFiles
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Required files has been downloaded correctly.${endColour}\n"
  else
    (wget "$htbMachines") &> /dev/null
    if [ "$(echo "$?")" != "0" ]; then
      echo -e "\n${redColour}[!] Error to extract required files, try again.${endColour}\n"
    fi
    (wget "$vulhubMachines") &> /dev/null
    if [ "$(echo "$?")" != "0" ]; then
      echo -e "\n${redColour}[!] Error to extract required files, try again.${endColour}\n"
    fi
  
    (wget "$otherMachines") &> /dev/null
    if [ "$(echo "$?")" != "0" ]; then
      echo -e "\n${redColour}[!] Error to extract required files, try again.${endColour}\n"
    fi
  
    cat "$htbName" | tail -n +4 | sponge "$htbName" &> /dev/null
    cat "$vulhubName" | tail -n +2 | sponge "$vulhubName" &> /dev/null
    cat "$otherName" | tail -n +3 | sponge "$otherName" &> /dev/null
    htbWeb="$( (md5sum "$htbName" | awk '{print $1}') 2> /dev/null)"
    vulhubWeb="$( (md5sum "$vulhubName" | awk '{print $1}') 2> /dev/null)"
    otherWeb="$( (md5sum "$otherName" | awk '{print $1}') 2> /dev/null)"
    htbLocal="$( (md5sum htbMachines.tsv | awk '{print $1}') 2> /dev/null)"
    vulhubLocal="$( (md5sum vulhubMachines.tsv | awk '{print $1}') 2> /dev/null)"
    otherLocal="$( (md5sum otherMachines.tsv | awk '{print $1}') 2> /dev/null)"
    rm -f "$htbName" &> /dev/null
    rm -f "$vulhubName" &> /dev/null
    rm -f "$otherName" &> /dev/null
  
    if [ "$htbWeb" == "$htbLocal" ] && [ "$vulhubWeb" == "$vulhubLocal" ] && [ "$otherWeb" == "$otherLocal" ]; then
      echo -e "\n${yellowColour}[+]${endColour} ${grayColour}¡No updates found, everything is up to date!${endColour}\n"
    else
      echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Updates found, applying...${endColour}\n"
      downloadFiles
      echo -e "\n${yellowColour}[+]${endColour} ${grayColour}All updates has been applied correctly.${endColour}\n"
    fi
  fi

  # recuperando el cursor
  tput cnorm
}

# Check for which platform found results
function verifyFilter(){
  htbMachines_check="$1"
  vulhubMachines_check="$2"
  otherMachines_check="$3"
  value=0
  count=0
  
  for line in $htbMachines_check; do
    if [ $count -gt 1 ]; then
      count=0
      break
    fi
    let count+=1
  done

  if [ $count -eq 1 ]; then
    let value+=1
    count=0
  fi
  
  for line in $vulhubMachines_check; do
    if [ $count -gt 1 ]; then
      count=0
      break
    fi
    let count+=1
  done

  if [ $count -eq 1 ]; then
    let value+=3
    count=0
  fi

  for line in $otherMachines_check; do
    if [ $count -gt 1 ]; then
      count=0
      break
    fi
    let count+=1
  done

  if [ $count -eq 1 ]; then
    let value+=5
    count=0
  fi
  
  return $value
}

# Helps to print all information of a machine in two parts, left and right -> Tags and Information
function helpToPrint(){
  machineTags="$1"
  machineInfo="$2"
  machinesPlatform="$3"
  count=1

  echo -e "${purpleColour}[-]${endColour} ${blueColour}Platform:${endColour} ${greenColour}$machinesPlatform${endColour}\n"
  for line in $machineTags; do
    Tag="$(echo "$line" | tr '\\' ' ')"
    Info="$(echo "$machineInfo" | sed -n "${count}p" | tr '\\' ' ')"
    echo -e "${blueColour}${Tag}:${endColour} ${grayColour}$Info${endColour}"
    let count+=1
  done
  echo ""
}

# Print the information of one machine when search by name
function printOneMachine(){
  machineTags="$1"
  machineInfo="$2"
  machinesPlatform="$3"
  
  helpToPrint "$machineTags" "$machineInfo" "$machinesPlatform"
}

# Print the information of two machines when seach by name
function printTwoMachines(){
  machine1Tags="$1"
  machine1Info="$2"
  machine1Platform="$3"
  machine2Tags="$4"
  machine2Info="$5"
  machine2Platform="$6"

  helpToPrint "$machine1Tags" "$machine1Info" "$machine1Platform"
  helpToPrint "$machine2Tags" "$machine2Info" "$machine2Platform"
}

# Print the information of three machines when search by name
function printThreeMachines(){
  machine1Tags="$1"
  machine1Info="$2"
  machine1Platform="$3"
  machine2Tags="$4"
  machine2Info="$5"
  machine2Platform="$6"
  machine3Tags="$7"
  machine3Info="$8"
  machine3Platform="$9"

  helpToPrint "$machine1Tags" "$machine1Info" "$machine1Platform"
  helpToPrint "$machine2Tags" "$machine2Info" "$machine2Platform"
  helpToPrint "$machine3Tags" "$machine3Info" "$machine3Platform"
}

# Check that the result found in a platform is only one. Further, this ensure that the search has been made correctly
function noReps(){
  htbMachines="$1"
  vulhubMachines="$2"
  otherMachines="$3"
  count=0
echo "$htbInfo" | awk 'BEGIN {IGNORECASE=1} {OFS="\t"} $1 ~ /'"$machineName"'/ {print $2}'
  for line in $htbMachines; do
    let count+=1
  done
  
  if [ $count -gt 1 ]; then
    return 1
  else
    count=0
  fi

  for line in $vulhubMachines; do
    let count+=1
  done

  if [ $count -gt 1 ]; then
    return 1
  else
    count=0
  fi

  for line in $otherMachines; do
    let count+=1
  done
  
  if [ $count -gt 1 ]; then
    return 1
  else
    return 0
  fi
}

# Print te information that indicates when machines information will be printed with the specific name of a machine
function ListTitle(){
  machine_check="$1"
  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Listing properties of the machine${endColour} ${blueColour}$machine_check${endColour}${grayColour}:${endColour}\n"
}

# Search a specific machine applying filters on the base files
function searchMachines(){
  machineName="$1"
  platform="$2"
  
  htbTags="$(cat htbMachines.tsv | head -n 1 | tr '\t' '\n' | tr ' ' '\\' | head -n -1)"
  vulhubTags="$(cat vulhubMachines.tsv | head -n 1 | tr '\t' '\n' | tr ' ' '\\' | head -n -1)"
  otherTags="$(cat otherMachines.tsv | head -n 1 | tr '\t' '\n' | tr ' ' '\\' | head -n -1)"
  htbMachines_check="$(cat htbMachines.tsv | tail -n +2 | awk -F'\t' '{print $1}' | grep "$machineName" -wi | tr '\t' '\n' | tr ' ' '\\')"
  vulhubMachines_check="$(cat vulhubMachines.tsv | tail -n +2 | awk -F'\t' '{print $1}' | grep "$machineName" -wi | tr '\t' '\n' | tr ' ' '\\')"
  otherMachines_check="$(cat otherMachines.tsv | tail -n +2 | awk -F'\t' '{print $1}' | grep "$machineName" -wi | tr '\t' '\n' | tr ' ' '\\')"

  machine_check="$htbMachines_check "
  machine_check+="$vulhubMachines_check "
  machine_check+="$otherMachines_check "
  machine_check="$(echo "$machine_check " | tr '\n' ' ' | sed 's/ \+$//' | tr ' ' '\n' | tail -n 1 | tr '\\' ' ' 2> /dev/null)"

  verifyFilter "$htbMachines_check" "$vulhubMachines_check" "$otherMachines_check"
  value=$?
  noReps "$htbMachines_check" "$vulhubMachines_check" "$otherMachines_check"
  reps=$?

  htbMachines_info="$(cat htbMachines.tsv | tail -n +2 | grep -P "^$machine_check\t" -i | tr '\t' '\n' | tr ' ' '\\')"
  vulhubMachines_info="$(cat vulhubMachines.tsv | tail -n +2 | grep -P "^$machine_check\t" -i | tr '\t' '\n' | tr ' ' '\\')"
  otherMachines_info="$(cat otherMachines.tsv | tail -n +2 | grep -P "^$machine_check\t" -i | tr '\t' '\n' | tr ' ' '\\')"

  if [ "$machine_check" != "" ] && [ $reps -eq 0 ] ; then

    if [ "$platform" == "$platform1" ]; then
      #htbMachines
      value=0
      if [ "$htbMachines_info" ]; then
        ListTitle "$machine_check"
        printOneMachine "$htbTags" "$htbMachines_info" "$Platform1"
        exit 0
      fi
    elif [ "$platform" == "$platform2" ]; then
      #vulhubMachines
      value=0
      if [ "$vulhubMachines_info" ]; then
        ListTitle "$machine_check"
        printOneMachine "$vulhubTags" "$vulhubMachines_info" "$Platform2"
        exit 0
      fi
    elif [ "$platform" == "$platform3" ]; then
      #otherMachines
      value=0
      if [ "$otherMachines_info" ]; then
        ListTitle "$machine_check"
        printOneMachine "$otherTags" "$otherMachines_info" "$Platform3"
        exit 0
      fi
    fi

    if [ $value -eq 1 ]; then
      #htbMachines
      ListTitle "$machine_check"
      printOneMachine "$htbTags" "$htbMachines_info" "$Platform1"
    elif [ $value -eq 3 ]; then
      #vulhubMachines
      ListTitle "$machine_check"
      printOneMachine "$vulhubTags" "$vulhubMachines_info" "$Platform2"
    elif [ $value -eq 5 ]; then
      #otherMachines
      ListTitle "$machine_check"
      printOneMachine "$otherTags" "$otherMachines_info" "$Platform3"
    elif [ $value -eq 4 ]; then
      #htbMachines y vulhubMachines
      ListTitle "$machine_check"
      printTwoMachines "$htbTags" "$htbMachines_info" "$Platform1" "$vulhubTags" "$vulhubMachines_info" "$Platform2"
    elif [ $value -eq 6 ]; then
      #htbMachines y otherMachines
      ListTitle "$machine_check"
      printTwoMachines "$htbTags" "$htbMachines_info" "$Platform1" "$otherTags" "$otherMachines_info" "$Platform3"
    elif [ $value -eq 8 ]; then
      #vulhubMachines y otherMachines
      ListTitle "$machine_check"
      printTwoMachines "$vulhubTags" "$vulhubMachines_info" "$Platform2" "$otherTags" "$otherMachines_info" "$Platform3"
    elif [ $value -eq 9 ]; then
      # htbMachines, vulhubMachines y otherMachines
      ListTitle "$machine_check"
      printThreeMachines "$htbTags" "$htbMachines_info" "$Platform1" "$vulhubTags" "$vulhubMachines_info" "$Platform2" "$otherTags" "$otherMachines_info" "$Platform3"
    else
      echo -e "\n${redColour}[!]${redColour} ${grayColour}The given machine is not available.${endColour}\n"
      exit 1
    fi
  else
    echo -e "\n${redColour}[!]${redColour} ${grayColour}The given machine is not available.${endColour}\n"
    exit 1
  fi
}

# Search a machine by an IP that the user has introduced
function searchIP(){
  scriptName="$1"
  ip="$2"
  ip_check="$(echo "$2" | tr -d ' ' | tr '.' '\n')"
  count=0
  
  # ocultando cursor
  tput civis

  for line in $ip_check; do
    let count+=1
  done

  if [ $count -eq 4 ]; then
    ip_check="$(cat htbMachines.tsv | grep -w "$ip" | awk -F'\t' '{print $1}')"

    if [ "$ip_check" ]; then
      echo -e "\n${yellowColour}[!]${endColour} ${grayColour}IP searches are only available for the platform${endColour} ${greenColour}HackTheBox${endColour}${grayColour}.${enColour}"
      sleep 1
      echo -e "\n${yellowColour}[+]${endColour} ${grayColour}The machine for the IP${endColour} ${blueColour}$ip${endColour} ${grayColour}is:${endColour} ${purpleColour}$ip_check${purpleColour}\n"
    else
      echo -e "\n${redColour}[!]${endColour} ${grayCololur}The given IP is not available.${endColour}\n"
    fi
  else
    echo -e "\n${redColour}[!] Usage:${ednColour} ${greenColour}$scriptName${endColour} ${grayColour}-i${endColour} ${yellowColour}\"10.10.10.10\"${endColour}\n"
    tput cnorm && exit 1
  fi
  # recuperando cursor
  tput cnorm
}

# Take the specific existing OS and show without repetitions
function printUniqOS(){
  htbOSUniq="$(cat htbMachines.tsv | tail -n +2 | awk -F'\t' '{print$3}' | sort | uniq | awk NF)"
  vulhubOSUniq="$(cat vulhubMachines.tsv | tail -n +2 | awk -F'\t' '{print$2}' | sort | uniq | awk NF)"
  otherOSUniq="$(cat otherMachines.tsv | tail -n +2 | awk -F'\t' '{print $2}' | sort | uniq | awk NF)"
  echo -e "\n\n${yellowColour}[!]${endColour} ${grayColour}Available operative systems:${endColour}\n"
  echo -e "\t${greenColour}$(echo -e "$htbOSUniq\n$vulhubOSUniq\n$otherOSUniq" | sort | uniq | tr '\n' ' ')${endColour}\n"
}

# For help to search betweenn two arguments by second argument, taking the first or the machine's name that is the same (optimization)
function searchInTwo(){
  argument1="$1"
  argument2="$2"
  search="$3"

  htbInfo="$(cat htbMachines.tsv | tail -n +2 | awk -F'\t' 'BEGIN {OFS="\t"} {print $'${argument1}',$'${argument2}'}')"
  argument2=$(($argument2-1))
  vulhubInfo="$(cat vulhubMachines.tsv | tail -n +2 | awk -F'\t' 'BEGIN {OFS="\t"} {print $'${argument1}',$'${argument2}'}')"
  otherInfo="$(cat otherMachines.tsv | tail -n +2 | awk -F'\t' 'BEGIN {OFS="\t"} {print $'${argument1}',$'${argument2}'}')"
  
  htbFilter="$(echo "$htbInfo" | awk -F'\t' 'BEGIN {IGNORECASE=1} $2 ~ /\<'"$search"'\>/ {print $1}')"
  vulhubFilter="$(echo "$vulhubInfo" | awk -F'\t' 'BEGIN {IGNORECASE=1} $2 ~ /\<'"$search"'\>/ {print $1}')"
  otherFilter="$(echo "$otherInfo" | awk -F'\t' 'BEGIN {IGNORECASE=1} $2 ~ /\<'"$search"'\>/ {print $1}')"
}

# For help to search betweenn two arguments by argument name, taking the second (optimization)
function searchNameInTwo(){
  argument1="$1"
  argument2="$2"
  search="$3"

  htbInfo="$(cat htbMachines.tsv | tail -n +2 | awk -F'\t' 'BEGIN {OFS="\t"} {print $'${argument1}',$'${argument2}'}')"
  vulhubInfo="$(cat vulhubMachines.tsv | tail -n +2 | awk -F'\t' 'BEGIN {OFS="\t"} {print $'${argument1}',$'${argument2}'}')"
  argument2=$(($argument2-1))
  otherInfo="$(cat otherMachines.tsv | tail -n +2 | awk -F'\t' 'BEGIN {OFS="\t"} {print $'${argument1}',$'${argument2}'}')"
  
  htbFilter="$(echo "$htbInfo" | awk -F'\t' 'BEGIN {IGNORECASE=1} $1 ~ /\<'"$search"'\>/ {print $2}')"
  vulhubFilter="$(echo "$vulhubInfo" | awk -F'\t' 'BEGIN {IGNORECASE=1} $1 ~ /\<'"$search"'\>/ {print $2}')"
  otherFilter="$(echo "$otherInfo" | awk -F'\t' 'BEGIN {IGNORECASE=1} $1 ~ /\<'"$search"'\>/ {print $2}')"
}


# For calculate just one value of the search and show the correct, like:
# user input: lInUx, porgram output: Linux
function takeOne(){
  search="$1"

  ONE="$(echo -e "$htbInfo" | awk -F'\t' 'BEGIN {IGNORECASE=1; OFS="\t"} $2 ~ /\<'"$search"'\>/ {print $2}' | sort | uniq | awk NF)\n"
  ONE+="$(echo -e "$vulhubInfo" | awk -F'\t' 'BEGIN {IGNORECASE=1; OFS="\t"} $2 ~ /\<'"$search"'\>/ {print $2}' | sort | uniq | awk NF)\n"
  ONE+="$(echo -e "$otherInfo" | awk -F'\t' 'BEGIN {IGNORECASE=1; OFS="\t"} $2 ~ /\<'"$search"'\>/ {print $2}' | sort | uniq | awk NF)"
  ONE="$(echo -e "$ONE" | sort | uniq | awk NF | tail -n 1)"

}

# For search by specific thing in the Info of the platform and get the specific name of that machine
function takeName(){
  search="$1"

  ONE="$(echo -e "$htbInfo" | awk -F'\t' 'BEGIN {IGNORECASE=1; OFS="\t"} $1 ~ /\<'"$search"'\>/ {print $1}' | sort | uniq | awk NF)\n"
  ONE+="$(echo -e "$vulhubInfo" | awk -F'\t' 'BEGIN {IGNORECASE=1; OFS="\t"} $1 ~ /\<'"$search"'\>/ {print $1}' | sort | uniq | awk NF)\n"
  ONE+="$(echo -e "$otherInfo" | awk -F'\t' 'BEGIN {IGNORECASE=1; OFS="\t"} $1 ~ /\<'"$search"'\>/ {print $1}' | sort | uniq | awk NF)"
  ONE="$(echo -e "$ONE" | sort | uniq | awk NF | tail -n 1)"

}

# To help to filter when you are searching by specific platform and just keep the specific platform (optimization)
function platformFilter(){
    platform="$1"
    text="$2"
    thing="$3"

    if [ "$platform" == "$platform1" ]; then
      vulhubFilter=""
      otherFilter=""
      check=1
      if [ ! "$htbFilter" ]; then
        echo -e "\n${yellowColour}[!]${endColour} ${greenColour}$Platform1${endColour} ${grayColour}$text${endColour} ${purpleColour}$thing${endColour}\n"
        exit 0
      fi
    elif [ "$platform" == "$platform2" ]; then
      htbFilter=""
      otherFilter=""
      check=1
      if [ ! "$vulhubFilter" ]; then
        echo -e "\n${yellowColour}[!]${endColour} ${greenColour}$Platform2${endColour} ${grayColour}$text${endColour} ${purpleColour}$thing${endColour}\n"
        exit 0
      fi
    elif [ "$platform" == "$platform3" ]; then
      vulhubFilter=""
      htbFilter=""
      check=1
      if [ ! "$otherFilter" ]; then
        echo -e "\n${yellowColour}[!]${endColour} ${greenColour}$Platform3${endColour} ${grayColour}$text${endColour} ${purpleColour}$thing${endColour}\n"
        exit 0
      fi
    fi
}

# Search by specific OS. Further, this allow to choose a specific platform with -p
function searchOS(){
  nameOS="$1"
  platform="$2"

  searchInTwo "1" "3" "$nameOS"
  
  takeOne "$nameOS"

  if [ "$htbFilter" ] || [ "$vulhubFilter" ] || [ "$otherFilter" ]; then
    platformFilter "$platform" "do not have machines" "$nameOS" # specific platform (-p)

    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Listing machines of operative system${endColour} ${purpleColour}$ONE${endColour}${grayColour}:${endColour}\n"
    sleep 1

    if [ "$htbFilter" ]; then
      if [ "$check" -eq 0 ]; then
        echo -e "\n${purpleColour}[-]${endColour} ${blueColour}Platform:${endColour} ${greenColour}$Platform1${grayColour}\n"
      fi
      echo "$htbFilter" | sort | column
    fi
    
    if [ "$vulhubFilter" ]; then
      if [ "$check" -eq 0 ]; then
        echo -e "\n${purpleColour}[-]${endColour} ${blueColour}Platform:${endColour} ${greenColour}$Platform2${grayColour}\n"
      fi
      echo "$vulhubFilter" | sort | column
    fi
    
    if [ "$otherFilter" ]; then
      if [ "$check" -eq 0 ]; then
        echo -e "\n${purpleColour}[-]${endColour} ${blueColour}Platform:${endColour} ${greenColour}$Platform3${grayColour}\n"
      fi
      echo "$otherFilter" | sort | column
    fi

    echo ""
  else
    echo -e "\n${redColour}[!]${redColour} ${grayColour}The given operative system is not available.${endColour}"
    printUniqOS
  fi
}

# Assigns a specific colour to a specific difficultie, if in a moment exist a new difficulty just give it the blue colour 
function DifficultyColour(){
  DIF="$1"
  unset DifficultieColour

  if [ "$DIF" == "Fácil" ]; then
    DifficultieColour="${greenColour}$DIF${endColour}"
  elif [ "$DIF" == "Media" ]; then
    DifficultieColour="${yellowColour}$DIF${endColour}"
  elif [ "$DIF" == "Difícil" ]; then
    DifficultieColour="${redColour}$DIF${endColour}"
  elif [ "$DIF" == "Insane" ]; then
    DifficultieColour="${purpleColour}$DIF${endColour}"
  elif [ "$DIF" ]; then
    DifficultieColour="${blueColour}$DIF${endColour}"
  fi
}

# Search in all difficulties a specific difficulties that exist in the three platform and show it, finally assigns a specific colour to them
function calculateDifficulties(){
  All="$(cat htbMachines.tsv | tail -n +2 | awk -F'\t' 'BEGIN {OFS="\t"} {print $4}' | sort | uniq | awk NF)\n"
  All+="$(cat vulhubMachines.tsv | tail -n +2 | awk -F'\t' 'BEGIN {OFS="\t"} {print $3}' | sort | uniq | awk NF)\n"
  All+="$(cat otherMachines.tsv | tail -n +2 | awk -F'\t' 'BEGIN {OFS="\t"} {print $3}' | sort | uniq | awk NF)"
  AllDiff="$(echo -e "$All" | awk NF | sort | uniq)"

  for line in $AllDiff; do
    DifficultyColour "$line"
    AllDifficulties+="$DifficultieColour\n"
  done
}

# Search machines by a specific difficultie. Further, this allow to choose a specific platform with -p (another function)
function searchDifficulty(){
  difficulty="$1"
  platform="$2"

  searchInTwo "1" "4" "$difficulty"

  takeOne "$difficulty"

  if [ "$htbFilter" ] || [ "$vulhubFilter" ] || [ "$otherFilter" ]; then
    DifficultyColour "$ONE" 

    platformFilter "$platform" "do not have machines with difficult" "$DifficultieColour" # specific platform (-p)

    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Listing machiones with difficult${endColour} $DifficultieColour${grayColour}:${endColour}\n"
    
    if [ "$htbFilter" ]; then
      if [ "$check" -eq 0 ]; then
        echo -e "\n${purpleColour}[-]${endColour} ${blueColour}Platform:${endColour} ${greenColour}$Platform1${endColour}\n"
      fi
      echo "$htbFilter" | sort | column
    fi

    if [ "$vulhubFilter" ]; then
      if [ "$check" -eq 0 ]; then
        echo -e "\n${purpleColour}[-]${endColour} ${blueColour}Platform:${endColour} ${greenColour}$Platform2${endColour}\n"
      fi
      echo "$vulhubFilter" | sort | column
    fi
    
    if [ "$otherFilter" ]; then
      if [ "$check" -eq 0 ]; then
        echo -e "\n${purpleColour}[-]${endColour} ${blueColour}Platform:${endColour} ${greenColour}$Platform3${endColour}\n"
      fi
      echo "$otherFilter" | sort | column
    fi

    echo ""
  else
    calculateDifficulties
    echo -e "\n${redColour}[!]${endColour} ${grayColour}The given difficulty is not available.${endColour}\n"
    echo -e "\n${yellowColour}[!]${endColour} ${grayColour}Available difficulties:${endColour}\n"
    echo -e "$AllDifficulties" | sort | tr '\n' ' '
    echo ""
  fi
}

# Search machines by a specific skill. Further, this allow to choose a specific platform with -p (another function)
function searchSkill(){
  skill="$1"
  platform="$2"

  searchInTwo "1" "5" "$skill"

  if [ "$htbFilter" ] || [ "$vulhubFilter" ] || [ "$otherFilter" ]; then
    platformFilter "$platform" "do not have machines with the skill" "$skill" # specific platform (-p)

    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Listing machines with the skill${endColour} ${blueColour}$skill${endColour}${grayColour}:${endColour}\n"

    if [ "$htbFilter" ]; then
      if [ "$check" -eq 0 ]; then
        echo -e "\n${purpleColour}[-]${endColour} ${blueColour}Platform:${endColour} ${greenColour}$Platform1${endColour}\n"
      fi
      echo "$htbFilter" | sort | column
      echo ""
    fi

    if [ "$vulhubFilter" ]; then
      if [ "$check" -eq 0 ]; then
        echo -e "\n${purpleColour}[-]${endColour} ${blueColour}Platform:${endColour} ${greenColour}$Platform2${endColour}\n"
      fi
      echo "$vulhubFilter" | sort | column
      echo ""
    fi
    
    if [ "$otherFilter" ]; then
      if [ "$check" -eq 0 ]; then
        echo -e "\n${purpleColour}[-]${endColour} ${blueColour}Platform:${endColour} ${greenColour}$Platform3${endColour}\n"
      fi
      echo "$otherFilter" | sort | column
      echo ""
    fi
  else
    echo -e "\n${redColour}[!] The given skill is not available.${endColour}\n"
    exit 1
  fi
}

# Search machines by a specific certification. Further, this allow to choose a specific platform with -p
function searchLike(){
  Like="$1"
  platform="$2"

  searchInTwo "1" "6" "$Like"

  if [ "$htbFilter" ] || [ "$vulhubFilter" ] || [ "$otherFilter" ]; then
    platformFilter "$platform" "do not have machines with certification" "$Like" # specific platform (-p)

    echo -e "\n${yellowColour}[+]${endColour}${grayColour}Listing machines with certification${endColour} ${blueColour}$Like${endColour}${grayColour}:${endColour}\n"
    
    if [ "$htbFilter" ]; then
      if [ "$check" -eq 0 ]; then
        echo -e "\n${purpleColour}[-]${endColour} ${blueColour}Platform:${endColour} ${greenColour}$Platform1${endColour}\n"
      fi
      echo "$htbFilter" | sort | column
      echo ""
    fi

    if [ "$vulhubFilter" ]; then
      if [ "$check" -eq 0 ]; then
        echo -e "\n${purpleColour}[-]${endColour} ${blueColour}Platform:${endColour} ${greenColour}$Platform2${endColour}\n"
      fi
      echo "$vulhubFilter" | sort | column
      echo ""
    fi

    if [ "$otherFilter" ]; then
      if [ "$check" -eq 0 ]; then
        echo -e "\n${purpleColour}[-]${endColour} ${blueColour}Platform:${endColour} ${greenColour}$Platform3${endColour}\n"
      fi
      echo "$otherFilter" | sort | column
      echo ""
    fi
  else
    echo -e "\n${redColour}[!] The given certification is not available.${endColour}\n"
    exit 1
  fi
}

# Search a machines by a name and extract the specific link of how you can solve the machine.
function getMachineLink(){
  machineName="$1"
  count=0

  searchNameInTwo "1" "7" "$machineName"

  takeName "$machineName"
  
  htbTags="$(echo "$htbInfo" | awk -F'\t' '{print $1}' | grep -wi "$machineName" | tr ' ' '\\')"
  vulhubTags="$(echo "$vulhubInfo" | awk -F'\t' '{print $1}' | grep -wi "$machineName" | tr ' ' '\\')"
  otherTags="$(echo "$otherInfo" | awk -F'\t' '{print $1}' | grep -wi "$machineName" | tr ' ' '\\')"

  if [ "$ONE" ]; then
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Listing the writeup for the machine${endColour} ${blueColour}$ONE${endColour}${grayColour}:${endColour}\n\n"
    if [ "$htbFilter" ]; then
      printOneMachine "$htbTags" "$htbFilter" "$Platform1"
      echo ""
    fi

    if [ "$vulhubFilter" ]; then
      printOneMachine "$vulhubTags" "$vulhubFilter" "$Platform2"
      echo ""
    fi

    if [ "$otherFilter" ]; then
      printOneMachine "$otherTags" "$otherFilter" "$Platform3"
      echo ""
    fi
  else
    echo -e "\n${redColour}[!] The given machine is not available.${endColour}\n"
    exit 1
  fi
}

# Help to search between three arguments by second argument then by third argument, finally take the first or the machine's name (optimization)
function searchInThree(){
  argument1="$1"
  argument2="$2"
  argument3="$3"
  search1="$4"
  search2="$5"

  htbInfo="$(cat htbMachines.tsv | tail -n +2 | awk -F'\t' 'BEGIN {OFS="\t"} {print $'$argument1',$'$argument2',$'$argument3'}')"
  argument2=$(($argument2-1))
  argument3=$(($argument3-1))
  vulhubInfo="$(cat vulhubMachines.tsv | tail -n +2 | awk -F'\t' 'BEGIN {OFS="\t"} {print $'$argument1',$'$argument2',$'$argument3'}')"
  otherInfo="$(cat otherMachines.tsv | tail -n +2 | awk -F'\t' 'BEGIN {OFS="\t"} {print $'$argument1',$'$argument2',$'$argument3'}')"

  htbSecond="$(echo "$htbInfo" | awk -F'\t' 'BEGIN {IGNORECASE=1; OFS="\t"} $2 ~ /\<'"$search1"'\>/ {print $1,$3}')"
  vulhubSecond="$(echo "$vulhubInfo" | awk -F'\t' 'BEGIN {IGNORECASE=1; OFS="\t"} $2 ~ /\<'"$search1"'\>/ {print $1,$3}')"
  otherSecond="$(echo "$otherInfo" | awk -F'\t' 'BEGIN {IGNORECASE=1; OFS="\t"} $2 ~ /\<'"$search1"'\>/ {print $1,$3}')"

  if [ "$htbSecond" ] || [ "$vulhubSecond" ] || [ "$otherSecond" ]; then
    htbFilter="$(echo "$htbSecond" | awk -F'\t' 'BEGIN {IGNORECASE=1} $2 ~ /\<'"$search2"'\>/ {print $1}')"
    vulhubFilter="$(echo "$vulhubSecond" | awk -F'\t' 'BEGIN {IGNORECASE=1} $2 ~ /\<'"$search2"'\>/ {print $1}')"
    otherFilter="$(echo "$otherSecond" | awk -F'\t' 'BEGIN {IGNORECASE=1} $2 ~ /\<'"$search2"'\>/ {print $1}')"

    takeOne "$search1"
  fi
}

# Search machines considering the filter by difficulty and skill at the same time. Further, this allow to choose a specific platform with -p
function getDiffSkill(){
  difficulty="$1"
  skill="$2"
  platform="$3"

  searchInThree "1" "4" "5" "$difficulty" "$skill"

  if [ "$htbFilter" ] || [ "$vulhubFilter" ] || [ "$otherFilter" ]; then
    DifficultyColour "$ONE"

    platformFilter "$platform" "do not have machines with difficulty $DifficultieColour, ${grayColour}which also has the skill${endColour}" "$skill" # specific platform (-p)
    
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Listing machines with difficulty${endColour} $DifficultieColour ${grayColour}which at the same time has the skill${endColour} ${purpleColour}$skill${endColour}${grayColour}:${endColour}\n"
    
    if [ "$htbFilter" ]; then
      if [ "$check" -eq 0 ]; then
        echo -e "\n${purpleColour}[-]${endColour} ${blueColour}Platform:${endColour} ${greenColour}$Platform1${endColour}\n"
      fi
      echo "$htbFilter" | sort | column
      echo ""
    fi

    if [ "$vulhubFilter" ]; then
      if [ "$check" -eq 0 ]; then
        echo -e "\n${purpleColour}[-]${endColour} ${blueColour}Platform:${endColour} ${greenColour}$Platform2${endColour}\n"
      fi
      echo "$vulhubFilter" | sort | column
      echo ""
    fi

    if [ "$otherFilter" ]; then
      if [ "$check" -eq 0 ]; then
        echo -e "\n${purpleColour}[-]${endColour} ${blueColour}Platform:${endColour} ${greenColour}$Platform3${endColour}\n"
      fi
      echo "$otherFilter" | sort | column
      echo ""
    fi
  else
    calculateDifficulties
    echo -e "\n${redColour}[!]${endColour} ${grayColour}One or both of the given difficulty and skill are not available.${endColour}\n"
    echo -e "\n${yellowColour}[!]${endColour} ${grayColour}Available difficulties:${endColour}\n"
    echo -e "$AllDifficulties" | sort | tr '\n' ' '
    echo -e "\n"
  fi
}

# Search machines considering the filter by difficulty and certification at the same time. Further, this allow to choose a specific platform with -p
function getDiffLike(){
  difficulty="$1"
  Like="$2"
  platform="$3"

  searchInThree "1" "4" "6" "$difficulty" "$Like"

  if [ "$htbFilter" ] || [ "$vulhubFilter" ] || [ "$otherFilter" ]; then
    DifficultyColour "$ONE"

    platformFilter "$platform" "do not have machines with difficult $DifficultieColour, ${grayColour}which also has the certification${endColour}" "$Like" # specific platform (-p)

    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Listing machines with difficult${endColour} $DifficultieColour ${grayColour}which also has the certification${endColour} ${purpleColour}$Like${endColour}${grayColour}:${endColour}\n"
    
    if [ "$htbFilter" ]; then
      if [ "$check" -eq 0 ]; then
        echo -e "\n${purpleColour}[-]${endColour} ${blueColour}Platform:${endColour} ${greenColour}$Platform1${endColour}\n"
      fi
      echo "$htbFilter" | sort | column
      echo ""
    fi

    if [ "$vulhubFilter" ]; then
      if [ "$check" -eq 0 ]; then
        echo -e "\n${purpleColour}[-]${endColour} ${blueColour}Platform:${endColour} ${greenColour}$Platform2${endColour}\n"
      fi
      echo "$vulhubFilter" | sort | column
      echo ""
    fi

    if [ "$otherFilter" ]; then
      if [ "$check" -eq 0 ]; then
        echo -e "\n${purpleColour}[-]${endColour} ${blueColour}Platform:${endColour} ${greenColour}$Platform3${endColour}\n"
      fi
      echo "$otherFilter" | sort | column
      echo ""
    fi
  else
    calculateDifficulties
    echo -e "\n${redColour}[!]${endColour} ${grayColour}One or both or the given difficulty and certification are not available.${endColour}\n"
    echo -e "\n${yellowColour}[!]${endColour} ${grayColour}Available difficulties:${endColour}\n"
    echo -e "$AllDifficulties" | sort | tr '\n' ' '
    echo -e "\n"
  fi
}

# Search machines considering the filter by difficulty and operative system at the same time. Further, this allow to choose a specific platform with -p
function getDiffOS(){
  difficulty="$1"
  os="$2"
  platform="$3"

  searchInThree "1" "4" "3" "$difficulty" "$os"

  OS="$(echo "$htbInfo" | awk -F'\t' 'BEGIN {IGNORECASE=1; OFS="\t"} $2 ~ /\<'"$difficulty"'\>/ {print $1,$3}' | awk -F'\t' 'BEGIN {IGNORECASE=1} $2 ~ /\<'"$os"'\>/ {print $2}' | head -n 1)\n"
  OS+="$(echo "$vulhubInfo" | awk -F'\t' 'BEGIN {IGNORECASE=1; OFS="\t"} $2 ~ /\<'"$difficulty"'\>/ {print $1,$3}' | awk -F'\t' 'BEGIN {IGNORECASE=1} $2 ~ /\<'"$os"'\>/ {print $2}' | head -n 1)\n"
  OS+="$(echo "$otherInfo" | awk -F'\t' 'BEGIN {IGNORECASE=1; OFS="\t"} $2 ~ /\<'"$difficulty"'\>/ {print $1,$3}' | awk -F'\t' 'BEGIN {IGNORECASE=1} $2 ~ /\<'"$os"'\>/ {print $2}' | head -n 1)"
  OS="$(echo -e "$OS" | awk NF | tr '\n' ' ' | awk '{print $1}')"

  if [ "$htbFilter" ] || [ "$vulhubFilter" ] || [ "$otherFilter" ]; then
    DifficultyColour "$ONE"

    platformFilter "$platform" "do not have machines with difficult $DifficultieColour, ${grayColour}which also has the operative system${endColour}" "$OS" # specific platform (-p)

    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Listing machines with difficult${endColour} $DifficultieColour ${grayColour}which also has the operative system${endColour} ${purpleColour}$OS${endColour}${grayColour}:${endColour}\n"
    
    if [ "$htbFilter" ]; then
      if [ "$check" -eq 0 ]; then
        echo -e "\n${purpleColour}[-]${endColour} ${blueColour}Platform:${endColour} ${greenColour}$Platform1${endColour}\n"
      fi
      echo "$htbFilter" | sort | column
      echo ""
    fi

    if [ "$vulhubFilter" ]; then
      if [ "$check" -eq 0 ]; then
        echo -e "\n${purpleColour}[-]${endColour} ${blueColour}Platform:${endColour} ${greenColour}$Platform2${endColour}\n"
      fi
      echo "$vulhubFilter" | sort | column
      echo ""
    fi

    if [ "$otherFilter" ]; then
      if [ "$check" -eq 0 ]; then
        echo -e "\n${purpleColour}[-]${endColour} ${blueColour}Platform:${endColour} ${greenColour}$Platform3${endColour}\n"
      fi
      echo "$otherFilter" | sort | column
      echo ""
    fi
  else
    calculateDifficulties
    echo -e "\n${redColour}[!]${endColour} ${grayColour}One or both of the given difficulty and operative system are not available.${endColour}\n"
    echo -e "\n${yellowColour}[!]${endColour} ${grayColour}Available difficulties:${endColour}\n"
    echo -e "$AllDifficulties" | sort | tr '\n' ' '
    printUniqOS
  fi
}

# Search machines considering the filter by skill and certification at the same time. Further, this allow to choose a specific platform with -p
function getSkillLike(){
  skill="$1"
  Like="$2"
  platform="$3"

  searchInThree "1" "5" "6" "$skill" "$Like"

  if [ "$htbFilter" ] || [ "$vulhubFilter" ] || [ "$otherFilter" ]; then

    platformFilter "$platform" "do not have machines with skill ${blueColour}$skill${endColour}, ${grayColour}which also has the certification${endColour}" "$Like" # specific platform (-p)

    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Listing machines with skill${endColour} ${yellowColour}$skill${endColour} ${grayColour}which also has the certification${endColour} ${purpleColour}$Like${endColour}${grayColour}:${endColour}\n"
    
    if [ "$htbFilter" ]; then
      if [ "$check" -eq 0 ]; then
        echo -e "\n${purpleColour}[-]${endColour} ${blueColour}Platform:${endColour} ${greenColour}$Platform1${endColour}\n"
      fi
      echo "$htbFilter" | sort | column
      echo ""
    fi

    if [ "$vulhubFilter" ]; then
      if [ "$check" -eq 0 ]; then
        echo -e "\n${purpleColour}[-]${endColour} ${blueColour}Platform:${endColour} ${greenColour}$Platform2${endColour}\n"
      fi
      echo "$vulhubFilter" | sort | column
      echo ""
    fi

    if [ "$otherFilter" ]; then
      if [ "$check" -eq 0 ]; then
        echo -e "\n${purpleColour}[-]${endColour} ${blueColour}Platform:${endColour} ${greenColour}$Platform3${endColour}\n"
      fi
      echo "$otherFilter" | sort | column
      echo ""
    fi
  else
    echo -e "\n${redColour}[!]${endColour} ${grayColour}One or both of the given skill and certification are not available.${endColour}\n"
    exit 0
  fi
}

# Search machines considering the filter by operative system and skill at the same time. Further, this allow to choose a specific platform with -p
function getOSSkill(){
  skill="$1"
  os="$2"
  platform="$3"

  searchInThree "1" "5" "3" "$skill" "$os"

  OS="$(echo "$htbInfo" | awk -F'\t' 'BEGIN {IGNORECASE=1; OFS="\t"} $2 ~ /\<'"$skill"'\>/ {print $1,$3}' | awk -F'\t' 'BEGIN {IGNORECASE=1} $2 ~ /\<'"$os"'\>/ {print $2}' | head -n 1)\n"
  OS+="$(echo "$vulhubInfo" | awk -F'\t' 'BEGIN {IGNORECASE=1; OFS="\t"} $2 ~ /\<'"$skill"'\>/ {print $1,$3}' | awk -F'\t' 'BEGIN {IGNORECASE=1} $2 ~ /\<'"$os"'\>/ {print $2}' | head -n 1)\n"
  OS+="$(echo "$otherInfo" | awk -F'\t' 'BEGIN {IGNORECASE=1; OFS="\t"} $2 ~ /\<'"$skill"'\>/ {print $1,$3}' | awk -F'\t' 'BEGIN {IGNORECASE=1} $2 ~ /\<'"$os"'\>/ {print $2}' | head -n 1)"
  OS="$(echo -e "$OS" | awk NF | tr '\n' ' ' | awk '{print $1}')"

  if [ "$htbFilter" ] || [ "$vulhubFilter" ] || [ "$otherFilter" ]; then

    platformFilter "$platform" "do not have machines with operative system ${blueColour}$OS${endColour}, ${grayColour}which also has the skill${endColour}" "$skill" # specific platform (-p)

    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Listing machines with skill${endColour} ${yellowColour}$skill${endColour} ${grayColour}which also has the operative system${endColour} ${blueColour}$OS${endColour}${grayColour}:${endColour}\n"
    
    if [ "$htbFilter" ]; then
      if [ "$check" -eq 0 ]; then
        echo -e "\n${purpleColour}[-]${endColour} ${blueColour}Platform:${endColour} ${greenColour}$Platform1${endColour}\n"
      fi
      echo "$htbFilter" | sort | column
      echo ""
    fi

    if [ "$vulhubFilter" ]; then
      if [ "$check" -eq 0 ]; then
        echo -e "\n${purpleColour}[-]${endColour} ${blueColour}Platform:${endColour} ${greenColour}$Platform2${endColour}\n"
      fi
      echo "$vulhubFilter" | sort | column
      echo ""
    fi

    if [ "$otherFilter" ]; then
      if [ "$check" -eq 0 ]; then
        echo -e "\n${purpleColour}[-]${endColour} ${blueColour}Platform:${endColour} ${greenColour}$Platform3${endColour}\n"
      fi
      echo "$otherFilter" | sort | column
      echo ""
    fi
  else
    echo -e "\n${redColour}[!]${endColour} ${grayColour}One or both of the given skill and operative system are not available.${endColour}"
    printUniqOS
    exit 0
  fi
}

# Search machines considering the filter by operative system and certification at the same time. Further, this allow to choose a specific platform with -p
function getOSLike(){
  Like="$1"
  os="$2"
  platform="$3"

  searchInThree "1" "6" "3" "$Like" "$os"

  OS="$(echo "$htbInfo" | awk -F'\t' 'BEGIN {IGNORECASE=1; OFS="\t"} $2 ~ /\<'"$Like"'\>/ {print $1,$3}' | awk -F'\t' 'BEGIN {IGNORECASE=1} $2 ~ /\<'"$os"'\>/ {print $2}' | head -n 1)\n"
  OS+="$(echo "$vulhubInfo" | awk -F'\t' 'BEGIN {IGNORECASE=1; OFS="\t"} $2 ~ /\<'"$Like"'\>/ {print $1,$3}' | awk -F'\t' 'BEGIN {IGNORECASE=1} $2 ~ /\<'"$os"'\>/ {print $2}' | head -n 1)\n"
  OS+="$(echo "$otherInfo" | awk -F'\t' 'BEGIN {IGNORECASE=1; OFS="\t"} $2 ~ /\<'"$Like"'\>/ {print $1,$3}' | awk -F'\t' 'BEGIN {IGNORECASE=1} $2 ~ /\<'"$os"'\>/ {print $2}' | head -n 1)"
  OS="$(echo -e "$OS" | awk NF | tr '\n' ' ' | awk '{print $1}')"

  if [ "$htbFilter" ] || [ "$vulhubFilter" ] || [ "$otherFilter" ]; then

    platformFilter "$platform" "do not have machines with operative system ${blueColour}$OS${endColour}, ${grayColour}which also has the certification${endColour}" "$Like" # specific platform (-p)

    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Listing machines with the certification${endColour} ${yellowColour}$Like${endColour} ${grayColour}which also has the operative system${endColour} ${blueColour}$OS${endColour}${grayColour}:${endColour}\n"
    
    if [ "$htbFilter" ]; then
      if [ "$check" -eq 0 ]; then
        echo -e "\n${purpleColour}[-]${endColour} ${blueColour}Platform:${endColour} ${greenColour}$Platform1${endColour}\n"
      fi
      echo "$htbFilter" | sort | column
      echo ""
    fi

    if [ "$vulhubFilter" ]; then
      if [ "$check" -eq 0 ]; then
        echo -e "\n${purpleColour}[-]${endColour} ${blueColour}Platform:${endColour} ${greenColour}$Platform2${endColour}\n"
      fi
      echo "$vulhubFilter" | sort | column
      echo ""
    fi

    if [ "$otherFilter" ]; then
      if [ "$check" -eq 0 ]; then
        echo -e "\n${purpleColour}[-]${endColour} ${blueColour}Platform:${endColour} ${greenColour}$Platform3${endColour}\n"
      fi
      echo "$otherFilter" | sort | column
      echo ""
    fi
  else
    echo -e "\n${redColour}[!]${endColour} ${grayColour}One or both of the given certificación and operative system are not available.${endColour}"
    printUniqOS
    exit 0
  fi
}

# For help to search between four arguments by second argument then by third argument and by fourth argument, finally take the first or the machine's name (optimization)
function searchInFour(){
  argument1="$1"
  argument2="$2"
  argument3="$3"
  argument4="$4"
  search1="$5"
  search2="$6"
  search3="$7"
## PENGINDG:
  htbInfo="$(cat htbMachines.tsv | tail -n +2 | awk -F'\t' 'BEGIN {OFS="\t"} {print $'$argument1',$'$argument2',$'$argument3',$'$argument4'}')"
  argument2=$(($argument2-1))
  argument3=$(($argument3-1))
  argument4=$(($argument4-1))
  vulhubInfo="$(cat vulhubMachines.tsv | tail -n +2 | awk -F'\t' 'BEGIN {OFS="\t"} {print $'$argument1',$'$argument2',$'$argument3',$'$argument4'}')"
  otherInfo="$(cat otherMachines.tsv | tail -n +2 | awk -F'\t' 'BEGIN {OFS="\t"} {print $'$argument1',$'$argument2',$'$argument3',$'$argument4'}')"

  htbSecond="$(echo "$htbInfo" | awk -F'\t' 'BEGIN {IGNORECASE=1; OFS="\t"} $3 ~ /\<'"$search1"'\>/ {print $1,$2,$4}')"
  vulhubSecond="$(echo "$vulhubInfo" | awk -F'\t' 'BEGIN {IGNORECASE=1; OFS="\t"} $3 ~ /\<'"$search1"'\>/ {print $1,$2,$4}')"
  otherSecond="$(echo "$otherInfo" | awk -F'\t' 'BEGIN {IGNORECASE=1; OFS="\t"} $3 ~ /\<'"$search1"'\>/ {print $1,$2,$4}')"

  htbThird="$(echo "$htbSecond" | awk -F'\t' 'BEGIN {IGNORECASE=1; OFS="\t"} $2 ~ /\<'"$search2"'\>/ {print $1,$3}')"
  vulhubThird="$(echo "$vulhubSecond" | awk -F'\t' 'BEGIN {IGNORECASE=1; OFS="\t"} $2 ~ /\<'"$search2"'\>/ {print $1,$3}')"
  otherThird="$(echo "$otherSecond" | awk -F'\t' 'BEGIN {IGNORECASE=1; OFS="\t"} $2 ~ /\<'"$search2"'\>/ {print $1,$3}')"
  if [ "$htbThird" ] || [ "$vulhubThird" ] || [ "$otherThird" ]; then
    htbFilter="$(echo "$htbThird" | awk -F'\t' 'BEGIN {IGNORECASE=1} $2 ~ /\<'"$search3"'\>/ {print $1}')"
    vulhubFilter="$(echo "$vulhubThird" | awk -F'\t' 'BEGIN {IGNORECASE=1} $2 ~ /\<'"$search3"'\>/ {print $1}')"
    otherFilter="$(echo "$otherThird" | awk -F'\t' 'BEGIN {IGNORECASE=1} $2 ~ /\<'"$search3"'\>/ {print $1}')"

    takeOne "$search2"
  fi
}

# Search machines by the OS - Difficultie - Skill that the user has introduced. Further, this allow to choose a specific platform with -p
function getOSDiffSkill(){
  skill="$1"
  os="$2"
  difficulty="$3"
  platform="$4"

  searchInFour "1" "4" "5" "3" "$skill" "$difficulty" "$os"

  OS="$(echo "$htbInfo" | awk -F'\t' 'BEGIN {IGNORECASE=1} $4 ~ /\<'"$os"'\>/ {print $4}' | head -n 1)\n"
  OS+="$(echo "$vulhubInfo" | awk -F'\t' 'BEGIN {IGNORECASE=1} $4 ~ /\<'"$os"'\>/ {print $4}' | head -n 1)\n"
  OS+="$(echo "$otherInfo" | awk -F'\t' 'BEGIN {IGNORECASE=1} $4 ~ /\<'"$os"'\>/ {print $4}' | head -n 1)"
  OS="$(echo -e "$OS" | awk NF | tr '\n' ' ' | awk '{print $1}')"

  if [ "$htbFilter" ] || [ "$vulhubFilter" ] || [ "$otherFilter" ]; then
    DifficultyColour "$ONE"

    platformFilter "$platform" "do not have machines with operative system ${blueColour}$OS${endColour}, $DifficultieColour ${grayColour}which also has the skill${endColour}" "$skill" # specific platform (-p)

    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Listing machines with operative system ${endColour}${blueColour}$OS${endColour}${grayColour},${endColour} $DifficultieColour which also has the skill ${yellowColour}$skill${endColour}${grayColour}:${endColour}\n"
    
    if [ "$htbFilter" ]; then
      if [ "$check" -eq 0 ]; then
        echo -e "\n${purpleColour}[-]${endColour} ${blueColour}Platform:${endColour} ${greenColour}$Platform1${endColour}\n"
      fi
      echo "$htbFilter" | sort | column
      echo ""
    fi

    if [ "$vulhubFilter" ]; then
      if [ "$check" -eq 0 ]; then
        echo -e "\n${purpleColour}[-]${endColour} ${blueColour}Platform:${endColour} ${greenColour}$Platform2${endColour}\n"
      fi
      echo "$vulhubFilter" | sort | column
      echo ""
    fi

    if [ "$otherFilter" ]; then
      if [ "$check" -eq 0 ]; then
        echo -e "\n${purpleColour}[-]${endColour} ${blueColour}Platform:${endColour} ${greenColour}$Platform3${endColour}\n"
      fi
      echo "$otherFilter" | sort | column
      echo ""
    fi
  else
    calculateDifficulties
    echo -e "\n${redColour}[!]${endColour} ${grayColour}One or all of the given dificulty, skill and operative system are not available.${endColour}"
    printUniqOS
    echo -e "${yellowColour}[!]${endColour} ${grayColour}Available difficulties:${endColour}\n"
    echo -e "$AllDifficulties" | sort | tr '\n' ' ' | awk NF
    exit 0
  fi
}

# Get machines with the OS - Difficultie - Certification that the user has introduced. Further, this allow to choose a specific platform with -p
function getOSDiffLike(){
  Like="$1"
  os="$2"
  difficulty="$3"
  platform="$4"

  searchInFour "1" "4" "6" "3" "$Like" "$difficulty" "$os"

  OS="$(echo "$htbInfo" | awk -F'\t' 'BEGIN {IGNORECASE=1} $4 ~ /\<'"$os"'\>/ {print $4}' | head -n 1)\n"
  OS+="$(echo "$vulhubInfo" | awk -F'\t' 'BEGIN {IGNORECASE=1} $4 ~ /\<'"$os"'\>/ {print $4}' | head -n 1)\n"
  OS+="$(echo "$otherInfo" | awk -F'\t' 'BEGIN {IGNORECASE=1} $4 ~ /\<'"$os"'\>/ {print $4}' | head -n 1)"
  OS="$(echo -e "$OS" | awk NF | tr '\n' ' ' | awk '{print $1}')"

  if [ "$htbFilter" ] || [ "$vulhubFilter" ] || [ "$otherFilter" ]; then
    DifficultyColour "$ONE"

    platformFilter "$platform" "do not have machines with difficult ${blueColour}$OS${endColour}, $DifficultieColour ${grayColour}which also has te certificación${endColour}" "$Like" # specific platform (-p)

    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Listing machines with operative system ${endColour}${blueColour}$OS${endColour}${grayColour},${endColour} $DifficultieColour which also has the certification ${yellowColour}$Like${endColour}${grayColour}:${endColour}\n"
    
    if [ "$htbFilter" ]; then
      if [ "$check" -eq 0 ]; then
        echo -e "\n${purpleColour}[-]${endColour} ${blueColour}Platform:${endColour} ${greenColour}$Platform1${endColour}\n"
      fi
      echo "$htbFilter" | sort | column
      echo ""
    fi

    if [ "$vulhubFilter" ]; then
      if [ "$check" -eq 0 ]; then
        echo -e "\n${purpleColour}[-]${endColour} ${blueColour}Platform:${endColour} ${greenColour}$Platform2${endColour}\n"
      fi
      echo "$vulhubFilter" | sort | column
      echo ""
    fi

    if [ "$otherFilter" ]; then
      if [ "$check" -eq 0 ]; then
        echo -e "\n${purpleColour}[-]${endColour} ${blueColour}Platform:${endColour} ${greenColour}$Platform3${endColour}\n"
      fi
      echo "$otherFilter" | sort | column
      echo ""
    fi
  else
    calculateDifficulties
    echo -e "\n${redColour}[!]${endColour} ${grayColour}One or all of the given dificulty, certification and operative system are not available.${endColour}"
    printUniqOS
    echo -e "${yellowColour}[!]${endColour} ${grayColour}Available difficulties:${endColour}\n"
    echo -e "$AllDifficulties" | sort | tr '\n' ' ' | awk NF
    exit 0
  fi
}

# Get machines with the OS - Skill - Certification that the user has introduced. Further, this allow to choose a specific platform with -p
function getOSSkillLike(){
  Like="$1"
  os="$2"
  skill="$3"
  platform="$4"

  searchInFour "1" "5" "6" "3" "$Like" "$skill" "$os"

  OS="$(echo "$htbInfo" | awk -F'\t' 'BEGIN {IGNORECASE=1} $4 ~ /\<'"$os"'\>/ {print $4}' | head -n 1)\n"
  OS+="$(echo "$vulhubInfo" | awk -F'\t' 'BEGIN {IGNORECASE=1} $4 ~ /\<'"$os"'\>/ {print $4}' | head -n 1)\n"
  OS+="$(echo "$otherInfo" | awk -F'\t' 'BEGIN {IGNORECASE=1} $4 ~ /\<'"$os"'\>/ {print $4}' | head -n 1)"
  OS="$(echo -e "$OS" | awk NF | tr '\n' ' ' | awk '{print $1}')"

  if [ "$htbFilter" ] || [ "$vulhubFilter" ] || [ "$otherFilter" ]; then

    platformFilter "$platform" "do not have machines with the operative system ${blueColour}$OS${endColour}, ${grayColour}which also has the skill${endColour} ${purpleColour}$skill${endColour} ${grayColour}and the certification${endColour}" "$Like"

    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Listing machines with the operative system ${endColour}${blueColour}$OS${endColour}${grayColour},${endColour} ${grayColour}cuya skill es${endColour} ${turquoiseColour}$skill${endColour} ${grayColour}and the certification${endColour} ${yellowColour}$Like${endColour}${grayColour}:${endColour}\n"
    
    if [ "$htbFilter" ]; then
      if [ "$check" -eq 0 ]; then
        echo -e "\n${purpleColour}[-]${endColour} ${blueColour}Platform:${endColour} ${greenColour}$Platform1${endColour}\n"
      fi
      echo "$htbFilter" | sort | column
      echo ""
    fi

    if [ "$vulhubFilter" ]; then
      if [ "$check" -eq 0 ]; then
        echo -e "\n${purpleColour}[-]${endColour} ${blueColour}Platform:${endColour} ${greenColour}$Platform2${endColour}\n"
      fi
      echo "$vulhubFilter" | sort | column
      echo ""
    fi

    if [ "$otherFilter" ]; then
      if [ "$check" -eq 0 ]; then
        echo -e "\n${purpleColour}[-]${endColour} ${blueColour}Platform:${endColour} ${greenColour}$Platform3${endColour}\n"
      fi
      echo "$otherFilter" | sort | column
      echo ""
    fi
  else
    echo -e "\n${redColour}[!]${endColour} ${grayColour}One or all of the given skill, certification and operative system are not available.${endColour}"
    printUniqOS
    exit 0
  fi
}

# Get machines with the Skill - Difficultie - Certification that the user has introduced. Further, this allow to choose a specific platform with -p
function getSkillDiffLike(){
  Like="$1"
  skill="$2"
  difficulty="$3"
  platform="$4"

  searchInFour "1" "4" "6" "5" "$Like" "$difficulty" "$skill"

  if [ "$htbFilter" ] || [ "$vulhubFilter" ] || [ "$otherFilter" ]; then
    DifficultyColour "$ONE"

    platformFilter "$platform" "do not have machines with difficult $DifficultieColour${grayColour}, which also has the skill${endColour} ${purpleColour}$skill${endColour} ${grayColour}and certification${endColour}" "$Like"

    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Listing machines with difficult $DifficultieColour${grayColour}, which also has the skill ${endColour}${turquoiseColour}$skill${endColour} ${grayColour}and certification${endColour} ${yellowColour}$Like${endColour}${grayColour}:${endColour}\n"
    
    if [ "$htbFilter" ]; then
      if [ "$check" -eq 0 ]; then
        echo -e "\n${purpleColour}[-]${endColour} ${blueColour}Platform:${endColour} ${greenColour}$Platform1${endColour}\n"
      fi
      echo "$htbFilter" | sort | column
      echo ""
    fi

    if [ "$vulhubFilter" ]; then
      if [ "$check" -eq 0 ]; then
        echo -e "\n${purpleColour}[-]${endColour} ${blueColour}Platform:${endColour} ${greenColour}$Platform2${endColour}\n"
      fi
      echo "$vulhubFilter" | sort | column
      echo ""
    fi

    if [ "$otherFilter" ]; then
      if [ "$check" -eq 0 ]; then
        echo -e "\n${purpleColour}[-]${endColour} ${blueColour}Platform:${endColour} ${greenColour}$Platform3${endColour}\n"
      fi
      echo "$otherFilter" | sort | column
      echo ""
    fi
  else
    calculateDifficulties
    echo -e "\n${redColour}[!]${endColour} ${grayColour}One or all of the given dificulty, certification and sill are not available.${endColour}\n"
    echo -e "${yellowColour}[!]${endColour} ${grayColour}Available difficulties:${endColour}\n"
    echo -e "$AllDifficulties" | sort | tr '\n' ' ' | awk NF
    exit 0
  fi
}

# Show to the user the existing platforms if is introduced a platform that does not exist
function showPlatforms(){
  echo -e "\n${redColour}[!] The given platform is not available.${endColour}\n"
  echo -e "${redColour}[!]${endColour} ${grayColour}The available platforms are:${endColour}\n\n\t${greenColour}$Platform1  $Platform2  $Platform3${endColour}\n"
  exit 1
}

# Get all machines adding the filter to show a specific platform (this is -p)
function getMachinesPlatform(){
    platform="$(echo "$1" | tr '[:upper:]' '[:lower:]')"
    platform1="$(echo "$Platform1" | tr '[:upper:]' '[:lower:]')"
    platform2="$(echo "$Platform2" | tr '[:upper:]' '[:lower:]')"
    platform3="$(echo "$Platform3" | tr '[:upper:]' '[:lower:]')"

    if [ "$platform" == "$platform1" ]; then
      echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Listing machines of the platform${endColour} ${greenColour}$Platform1${endColour}\n"
      cat htbMachines.tsv | tail -n +2 | awk -F'\t' '{print $1}' | column
      echo ""
    elif [ "$platform" == "$platform2" ]; then
      echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Listing machines of the platform${endColour} ${greenColour}$Platform2${endColour}\n"
      cat vulhubMachines.tsv | tail -n +2 | awk -F'\t' '{print $1}' | column
      echo ""
    elif [ "$platform" == "$platform3" ]; then
      echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Listing machines of the platform${endColour} ${greenColour}$Platform3${endColour}\n"
      cat otherMachines.tsv | tail -n +2 | awk -F'\t' '{print $1}' | column
      echo ""
    else
      showPlatforms
    fi
}

# Get machines searching by name, adding the filter to show a specific platform (this is -p)
function getPlatformMachine(){
  platform="$(echo "$1" | tr '[:upper:]' '[:lower:]')"
  platform1="$(echo "$Platform1" | tr '[:upper:]' '[:lower:]')"
  platform2="$(echo "$Platform2" | tr '[:upper:]' '[:lower:]')"
  platform3="$(echo "$Platform3" | tr '[:upper:]' '[:lower:]')"
  
  machineName="$2"

  if [ "$platform" == "$platform1" ] || [ "$platform" == "$platform2" ] || [ "$platform" == "$platform3" ]; then
    searchMachines "$machineName" "$platform"
  else
    showPlatforms
  fi
}

# Get machines searching by operative system, adding the filter to show a specific platform (this is -p)
function getPlatformOS(){
  platform="$(echo "$1" | tr '[:upper:]' '[:lower:]')"
  platform1="$(echo "$Platform1" | tr '[:upper:]' '[:lower:]')"
  platform2="$(echo "$Platform2" | tr '[:upper:]' '[:lower:]')"
  platform3="$(echo "$Platform3" | tr '[:upper:]' '[:lower:]')"
  
  machineOS="$2"

  if [ "$platform" == "$platform1" ] || [ "$platform" == "$platform2" ] || [ "$platform" == "$platform3" ]; then
    searchOS "$machineOS" "$platform"
  else
    showPlatforms
  fi
}

# Get machines searching by difficulty, adding the filter to show a specific platform (this is -p)
function getPlatformDIF(){
  platform="$(echo "$1" | tr '[:upper:]' '[:lower:]')"
  platform1="$(echo "$Platform1" | tr '[:upper:]' '[:lower:]')"
  platform2="$(echo "$Platform2" | tr '[:upper:]' '[:lower:]')"
  platform3="$(echo "$Platform3" | tr '[:upper:]' '[:lower:]')"
  
  difficulty="$2"

  if [ "$platform" == "$platform1" ] || [ "$platform" == "$platform2" ] || [ "$platform" == "$platform3" ]; then
    searchDifficulty "$difficulty" "$platform"
  else
    showPlatforms
  fi
}

# Get machines searching by skill, adding the filter to show a specific platform (this is -p)
function getPlatformSkill(){
  platform="$(echo "$1" | tr '[:upper:]' '[:lower:]')"
  platform1="$(echo "$Platform1" | tr '[:upper:]' '[:lower:]')"
  platform2="$(echo "$Platform2" | tr '[:upper:]' '[:lower:]')"
  platform3="$(echo "$Platform3" | tr '[:upper:]' '[:lower:]')"
  
  skill="$2"

  if [ "$platform" == "$platform1" ] || [ "$platform" == "$platform2" ] || [ "$platform" == "$platform3" ]; then
    searchSkill "$skill" "$platform"
  else
    showPlatforms
  fi
}

# Get machines searching by certification, adding the filter to show a specific platform (this is -p)
function getPlatformLike(){
  platform="$(echo "$1" | tr '[:upper:]' '[:lower:]')"
  platform1="$(echo "$Platform1" | tr '[:upper:]' '[:lower:]')"
  platform2="$(echo "$Platform2" | tr '[:upper:]' '[:lower:]')"
  platform3="$(echo "$Platform3" | tr '[:upper:]' '[:lower:]')"
  
  Like="$2"

  if [ "$platform" == "$platform1" ] || [ "$platform" == "$platform2" ] || [ "$platform" == "$platform3" ]; then
    searchLike "$Like" "$platform"
  else
    showPlatforms
  fi
}

# Get machines searching by difficulty and skill at the same time, adding the filter to show a specific platform (this is -p)
function getPlatformDiffSkill(){
  platform="$(echo "$1" | tr '[:upper:]' '[:lower:]')"
  platform1="$(echo "$Platform1" | tr '[:upper:]' '[:lower:]')"
  platform2="$(echo "$Platform2" | tr '[:upper:]' '[:lower:]')"
  platform3="$(echo "$Platform3" | tr '[:upper:]' '[:lower:]')"
  
  difficulty="$2"
  skill="$3"

  if [ "$platform" == "$platform1" ] || [ "$platform" == "$platform2" ] || [ "$platform" == "$platform3" ]; then
    getDiffSkill "$difficulty" "$skill" "$platform"
  else
    showPlatforms
  fi
}

# Get machines searching by difficulty and certification at the same time, adding the filter to show a specific platform (this is -p)
function getPlatformDiffLike(){
  platform="$(echo "$1" | tr '[:upper:]' '[:lower:]')"
  platform1="$(echo "$Platform1" | tr '[:upper:]' '[:lower:]')"
  platform2="$(echo "$Platform2" | tr '[:upper:]' '[:lower:]')"
  platform3="$(echo "$Platform3" | tr '[:upper:]' '[:lower:]')"
  
  difficulty="$2"
  Like="$3"

  if [ "$platform" == "$platform1" ] || [ "$platform" == "$platform2" ] || [ "$platform" == "$platform3" ]; then
    getDiffLike "$difficulty" "$Like" "$platform"
  else
    showPlatforms
  fi
}

# Get machines searching by difficulty and operative system at the same time, adding the filter to show a specific platform (this is -p)
function getPlatformDiffOS(){
  platform="$(echo "$1" | tr '[:upper:]' '[:lower:]')"
  platform1="$(echo "$Platform1" | tr '[:upper:]' '[:lower:]')"
  platform2="$(echo "$Platform2" | tr '[:upper:]' '[:lower:]')"
  platform3="$(echo "$Platform3" | tr '[:upper:]' '[:lower:]')"
  
  difficulty="$2"
  os="$3"

  if [ "$platform" == "$platform1" ] || [ "$platform" == "$platform2" ] || [ "$platform" == "$platform3" ]; then
    getDiffOS "$difficulty" "$os" "$platform"
  else
    showPlatforms
  fi
}

# Get machines searching by skill and certification at the same time, adding the filter to show a specific platform (this is -p)
function getPlatformSkillLike(){
  platform="$(echo "$1" | tr '[:upper:]' '[:lower:]')"
  platform1="$(echo "$Platform1" | tr '[:upper:]' '[:lower:]')"
  platform2="$(echo "$Platform2" | tr '[:upper:]' '[:lower:]')"
  platform3="$(echo "$Platform3" | tr '[:upper:]' '[:lower:]')"
  
  skill="$2"
  Like="$3"

  if [ "$platform" == "$platform1" ] || [ "$platform" == "$platform2" ] || [ "$platform" == "$platform3" ]; then
    getSkillLike "$skill" "$Like" "$platform"
  else
    showPlatforms
  fi
}

# Get machines searching by operative system and skill at the same time, adding the filter to show a specific platform (this is -p)
function getPlatformOSSkill(){
  platform="$(echo "$1" | tr '[:upper:]' '[:lower:]')"
  platform1="$(echo "$Platform1" | tr '[:upper:]' '[:lower:]')"
  platform2="$(echo "$Platform2" | tr '[:upper:]' '[:lower:]')"
  platform3="$(echo "$Platform3" | tr '[:upper:]' '[:lower:]')"
  
  skill="$2"
  os="$3"

  if [ "$platform" == "$platform1" ] || [ "$platform" == "$platform2" ] || [ "$platform" == "$platform3" ]; then
    getOSSkill "$skill" "$os" "$platform"
  else
    showPlatforms
  fi
}

# Get machines searching by operative system and certification at the same time, adding the filter to show a specific platform (this is -p)
function getPlatformOSLike(){
  platform="$(echo "$1" | tr '[:upper:]' '[:lower:]')"
  platform1="$(echo "$Platform1" | tr '[:upper:]' '[:lower:]')"
  platform2="$(echo "$Platform2" | tr '[:upper:]' '[:lower:]')"
  platform3="$(echo "$Platform3" | tr '[:upper:]' '[:lower:]')"
  
  Like="$2"
  os="$3"

  if [ "$platform" == "$platform1" ] || [ "$platform" == "$platform2" ] || [ "$platform" == "$platform3" ]; then
    getOSLike "$Like" "$os" "$platform"
  else
    showPlatforms
  fi
}

# Get machines searching by operative system, difficulty and skill at the same time, adding the filter to show a specific platform (this is -p)
function getPlatformOSDiffSkill(){
  platform="$(echo "$1" | tr '[:upper:]' '[:lower:]')"
  platform1="$(echo "$Platform1" | tr '[:upper:]' '[:lower:]')"
  platform2="$(echo "$Platform2" | tr '[:upper:]' '[:lower:]')"
  platform3="$(echo "$Platform3" | tr '[:upper:]' '[:lower:]')"
  
  skill="$2"
  os="$3"
  difficulty="$4"

  if [ "$platform" == "$platform1" ] || [ "$platform" == "$platform2" ] || [ "$platform" == "$platform3" ]; then
    getOSDiffSkill "$skill" "$os" "$difficulty" "$platform"
  else
    showPlatforms
  fi
}

# Get machines searching by operative system, difficulty and certification at the same time, adding the filter to show a specific platform (this is -p)
function getPlatformOSDiffLike(){
  platform="$(echo "$1" | tr '[:upper:]' '[:lower:]')"
  platform1="$(echo "$Platform1" | tr '[:upper:]' '[:lower:]')"
  platform2="$(echo "$Platform2" | tr '[:upper:]' '[:lower:]')"
  platform3="$(echo "$Platform3" | tr '[:upper:]' '[:lower:]')"
  
  Like="$2"
  os="$3"
  difficulty="$4"

  if [ "$platform" == "$platform1" ] || [ "$platform" == "$platform2" ] || [ "$platform" == "$platform3" ]; then
    getOSDiffLike "$Like" "$os" "$difficulty" "$platform"
  else
    showPlatforms
  fi
}

# Get machines searching by operative system, skill and certification at the same time, adding the filter to show a specific platform (this is -p)
function getPlatformOSSkillLike(){
  platform="$(echo "$1" | tr '[:upper:]' '[:lower:]')"
  platform1="$(echo "$Platform1" | tr '[:upper:]' '[:lower:]')"
  platform2="$(echo "$Platform2" | tr '[:upper:]' '[:lower:]')"
  platform3="$(echo "$Platform3" | tr '[:upper:]' '[:lower:]')"
  
  Like="$2"
  os="$3"
  skill="$4"

  if [ "$platform" == "$platform1" ] || [ "$platform" == "$platform2" ] || [ "$platform" == "$platform3" ]; then
    getOSSkillLike "$Like" "$os" "$skill" "$platform"
  else
    showPlatforms
  fi
}

# Get machines searching by skill, difficulty and certification at the same time, adding the filter to show a specific platform (this is -p)
function getPlatformSkillDiffLike(){
  platform="$(echo "$1" | tr '[:upper:]' '[:lower:]')"
  platform1="$(echo "$Platform1" | tr '[:upper:]' '[:lower:]')"
  platform2="$(echo "$Platform2" | tr '[:upper:]' '[:lower:]')"
  platform3="$(echo "$Platform3" | tr '[:upper:]' '[:lower:]')"
  
  Like="$2"
  skill="$3"
  difficulty="$4"

  if [ "$platform" == "$platform1" ] || [ "$platform" == "$platform2" ] || [ "$platform" == "$platform3" ]; then
    getSkillDiffLike "$Like" "$skill" "$difficulty" "$platform"
  else
    showPlatforms
  fi
}

## Declaration of an int variables for the correct operation of each parameter and chivato (chivato's are used to search when the user search by combinations of parameters)
# Indicadores
declare -i parameter_counter=0

# Chivatos
declare -i chivato_m=0
declare -i chivato_o=0
declare -i chivato_d=0
declare -i chivato_s=0
declare -i chivato_l=0
declare -i chivato_p=0

# Declaration of parameter with WHILE GETOPTS
while getopts "um:i:o:d:s:c:y:p:klh" arg; do
  case $arg in
    u) let parameter_counter+=1;;
    m) machineName="$OPTARG"; let chivato_m+=1; let parameter_counter+=2;;
    i) machineIP="$OPTARG"; let parameter_counter+=3;;
    o) machineOS="$OPTARG"; let chivato_o+=1; let parameter_counter+=4;;
    d) difficulty="$OPTARG"; let chivato_d+=1; let parameter_counter+=5;;
    s) skill="$OPTARG"; let chivato_s+=1; let parameter_counter+=6;;
    c) Like="$OPTARG"; let chivato_l+=1; let parameter_counter+=7;;
    y) Name="$OPTARG"; let parameter_counter+=8;;
    p) platform="$OPTARG"; let chivato_p+=1; let parameter_counter+=9;;
    k) let parameter_counter+=10;;
    l) let parameter_counter+=11;;
    h) ;;
  esac
done

## Comprobation of what need to search the user and execute the specific function
if [ $chivato_p -eq 1 ] && [ $chivato_s -eq 1 ] && [ $chivato_o -eq 1 ] && [ $chivato_d -eq 1 ]; then
  getPlatformOSDiffSkill "$platform" "$skill" "$machineOS" "$difficulty"
elif [ $chivato_p -eq 1 ] && [ $chivato_l -eq 1 ] && [ $chivato_o -eq 1 ] && [ $chivato_d -eq 1 ]; then
  getPlatformOSDiffLike "$platform" "$Like" "$machineOS" "$difficulty"
elif [ $chivato_p -eq 1 ] && [ $chivato_l -eq 1 ] && [ $chivato_o -eq 1 ] && [ $chivato_s -eq 1 ]; then
  getPlatformOSSkillLike "$platform" "$Like" "$machineOS" "$skill"
elif [ $chivato_p -eq 1 ] && [ $chivato_l -eq 1 ] && [ $chivato_s -eq 1 ] && [ $chivato_d -eq 1 ]; then
  getPlatformSkillDiffLike "$platform" "$Like" "$skill" "$difficulty"
elif [ $chivato_p -eq 1 ] && [ $chivato_d -eq 1 ] && [ $chivato_s -eq 1 ]; then
  getPlatformDiffSkill "$platform" "$difficulty" "$skill"
elif [ $chivato_p -eq 1 ] && [ $chivato_d -eq 1 ] && [ $chivato_l -eq 1 ]; then
  getPlatformDiffLike "$platform" "$difficulty" "$Like"
elif [ $chivato_p -eq 1 ] && [ $chivato_d -eq 1 ] && [ $chivato_o -eq 1 ]; then
  getPlatformDiffOS "$platform" "$difficulty" "$machineOS"
elif [ $chivato_p -eq 1 ] && [ $chivato_s -eq 1 ] && [ $chivato_l -eq 1 ]; then
  getPlatformSkillLike "$platform" "$skill" "$Like"
elif [ $chivato_p -eq 1 ] && [ $chivato_s -eq 1 ] && [ $chivato_o -eq 1 ]; then
  getPlatformOSSkill "$platform" "$skill" "$machineOS"
elif [ $chivato_p -eq 1 ] && [ $chivato_l -eq 1 ] && [ $chivato_o -eq 1 ]; then
  getPlatformOSLike "$platform" "$Like" "$machineOS"
elif [ $chivato_s -eq 1 ] && [ $chivato_o -eq 1 ] && [ $chivato_d -eq 1 ]; then
  getOSDiffSkill "$skill" "$machineOS" "$difficulty"
elif [ $chivato_l -eq 1 ] && [ $chivato_o -eq 1 ] && [ $chivato_d -eq 1 ]; then
  getOSDiffLike "$Like" "$machineOS" "$difficulty"
elif [ $chivato_l -eq 1 ] && [ $chivato_o -eq 1 ] && [ $chivato_s -eq 1 ]; then
  getOSSkillLike "$Like" "$machineOS" "$skill"
elif [ $chivato_l -eq 1 ] && [ $chivato_d -eq 1 ] && [ $chivato_s -eq 1 ]; then
  getSkillDiffLike "$Like" "$skill" "$difficulty"
elif [ $chivato_d -eq 1 ] && [ $chivato_s -eq 1 ]; then
  getDiffSkill "$difficulty" "$skill"
elif [ $chivato_d -eq 1 ] && [ $chivato_l -eq 1 ]; then
  getDiffLike "$difficulty" "$Like"
elif [ $chivato_d -eq 1 ] && [ $chivato_o -eq 1 ]; then
  getDiffOS "$difficulty" "$machineOS"
elif [ $chivato_s -eq 1 ] && [ $chivato_l -eq 1 ]; then
  getSkillLike "$skill" "$Like"
elif [ $chivato_s -eq 1 ] && [ $chivato_o -eq 1 ]; then
  getOSSkill "$skill" "$machineOS"
elif [ $chivato_l -eq 1 ] && [ $chivato_o -eq 1 ]; then
  getOSLike "$Like" "$machineOS"
elif [ $chivato_m -eq 1 ] && [ $chivato_p -eq 1 ]; then
  getPlatformMachine "$platform" "$machineName"
elif [ $chivato_o -eq 1 ] && [ $chivato_p -eq 1 ]; then
  getPlatformOS "$platform" "$machineOS"
elif [ $chivato_d -eq 1 ] && [ $chivato_p -eq 1 ]; then
  getPlatformDIF "$platform" "$difficulty"
elif [ $chivato_s -eq 1 ] && [ $chivato_p -eq 1 ]; then
  getPlatformSkill "$platform" "$skill"
elif [ $chivato_l -eq 1 ] && [ $chivato_p -eq 1 ]; then
  getPlatformLike "$platform" "$Like"
elif [ $parameter_counter -eq 1 ]; then
  updateFiles
elif [ $parameter_counter -eq 2 ]; then
  searchMachines "$machineName"
elif [ $parameter_counter -eq 3 ]; then
  searchIP "$fileName" "$machineIP"
elif [ $parameter_counter -eq 4 ]; then
  searchOS "$machineOS"
elif [ $parameter_counter -eq 5 ]; then
  searchDifficulty "$difficulty"
elif [ $parameter_counter -eq 6 ]; then
  searchSkill "$skill"
elif [ $parameter_counter -eq 7 ]; then
  searchLike "$Like"
elif [ $parameter_counter -eq 8 ]; then
  getMachineLink "$Name"
elif [ $parameter_counter -eq 9 ]; then
  getMachinesPlatform "$platform"
elif [ $parameter_counter -eq 10 ]; then
  showCombinations
elif [ $parameter_counter -eq 11 ]; then
  showParameterP
else
  helpPanel
fi
