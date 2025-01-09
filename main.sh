#!/bin/bash
#Author: L44x

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"
whiteColour="\e[1;37m"

trap ctrl_c INT

function ctrl_c(){
    echo -e "\n\n${redColour}[!] Saliendo... :) \n${endColour}"
    exit 0
}

function banner() {
  echo -e "\n\n\n ${blueColour}__      .____     _____     _____ ____  ___       __${endColour} "
  echo -e " ${blueColour}\ \     |    |      /  |  |   /  |  |\   \/  /     / /${endColour} "
  echo -e " ${redColour} \ \    |    |     /   |  |_ /   |  |_\     /     / /${endColour}           ${purpleColour}👑${endColour} ${yellowColour}GitHub${endColour} ${redColour}>${endColour} ${whiteColour}https://${endColour}${redColour}github.com/${endColour}${whiteColour}l44x${endColour}"
  echo -e " ${redColour} / /    |    |___ /    ^   //    ^   //     \     \ \ ${endColour} "
  echo -e " ${blueColour}/_/     |_______ \\____   | \____   |/___/\  \      \_\ ${endColour}"
  echo -e " ${blueColour}                \/     |__|      |__|      \_/         ${endColour}"
  echo -e "                                                       "  
  echo -e "                          [${redColour}███${endColour}${whiteColour}███${endColour}${redColour}███${endColour}] \n\n\n"
}

function helpPanel(){
  banner
  echo -e "${purpleColour}=========================================================${endColour}"
  echo -e "\t\t${yellowColour}[*]${endColour}${grayColour} Uso: ./bash-scripting05.sh ${endColour}\n"
  echo -e "\t${redColour}|${endColour} ${turquoiseColour}[-a maquinas_activas]${endColour} ${redColour}|${endColour}${greenColour} Mostrar todas las maquinas.${endColour}"
  echo -e "\t${redColour}|${endColour} ${turquoiseColour}[-c]${endColour} ${redColour}|${endColour}${greenColour} Agregar por nombre de maquina.${endColour}"
  echo -e "\t${redColour}|${endColour} ${turquoiseColour}[-f]${endColour} ${redColour}|${endColour}${greenColour} Filtrar por nombre de maquina.${endColour}"
  echo -e "\t${redColour}|${endColour} ${turquoiseColour}[-d]${endColour} ${redColour}|${endColour}${greenColour} Eliminar por nombre de maquina.${endColour}"
  echo -e "\t${redColour}|${endColour} ${turquoiseColour}[-m]${endColour} ${redColour}|${endColour}${greenColour} Cambiar estado de maquina por nombre.${endColour}"
  echo -e "\t${redColour}|${endColour} ${turquoiseColour}[-s]${endColour} ${redColour}|${endColour}${greenColour} Filtrar por maquinas resueltas y vistas.${endColour}"
  echo -e "\t${redColour}|${endColour} ${turquoiseColour}[-h]${endColour} ${redColour}|${endColour}${greenColour} Mostrar el panel de ayuda.${endColour}"
  echo -e "\n\t\t\t${yellowColour}[👑]${endColour}${grayColour} By: L44x ${endColour}"
  echo -e "${purpleColour}=========================================================${endColour}\n\n"
}

#----------------------------------------------------------------------------------------

function printTable(){

    local -r delimiter="${1}"
    local -r data="$(removeEmptyLines "${2}")"

    if [[ "${delimiter}" != '' && "$(isEmptyString "${data}")" = 'false' ]]
    then
        local -r numberOfLines="$(wc -l <<< "${data}")"

        if [[ "${numberOfLines}" -gt '0' ]]
        then
            local table=''
            local i=1

            for ((i = 1; i <= "${numberOfLines}"; i = i + 1))
            do
                local line=''
                line="$(sed "${i}q;d" <<< "${data}")"

                local numberOfColumns='0'
                numberOfColumns="$(awk -F "${delimiter}" '{print NF}' <<< "${line}")"

                if [[ "${i}" -eq '1' ]]
                then
                    table="${table}$(printf '%s#+' "$(repeatString '#+' "${numberOfColumns}")")"
                fi

                table="${table}\n"

                local j=1

                for ((j = 1; j <= "${numberOfColumns}"; j = j + 1))
                do
                    table="${table}$(printf '#| %s' "$(cut -d "${delimiter}" -f "${j}" <<< "${line}")")"
                done

                table="${table}#|\n"

                if [[ "${i}" -eq '1' ]] || [[ "${numberOfLines}" -gt '1' && "${i}" -eq "${numberOfLines}" ]]
                then
                    table="${table}$(printf '%s#+' "$(repeatString '#+' "${numberOfColumns}")")"
                fi
            done

            if [[ "$(isEmptyString "${table}")" = 'false' ]]
            then
                echo -e "${table}" | column -s '#' -t | awk '/^\+/{gsub(" ", "-", $0)}1'
            fi
        fi
    fi
}

function removeEmptyLines(){

    local -r content="${1}"
    echo -e "${content}" | sed '/^\s*$/d'
}

function repeatString(){

    local -r string="${1}"
    local -r numberToRepeat="${2}"

    if [[ "${string}" != '' && "${numberToRepeat}" =~ ^[1-9][0-9]*$ ]]
    then
        local -r result="$(printf "%${numberToRepeat}s")"
        echo -e "${result// /${string}}"
    fi
}

function isEmptyString(){
    local -r string="${1}"
    if [[ "$(trimString "${string}")" = '' ]]
    then
        echo 'true' && return 0
    fi
    echo 'false' && return 1
}

function trimString(){
    local -r string="${1}"
    sed 's,^[[:blank:]]*,,' <<< "${string}" | sed 's,[[:blank:]]*$,,'
}
#-----------------------------------------------------------------------------------------

function getAllMachines() {
    echo -e "Mostrando todas las máquinas:"
    # cat titles | grep "HackTheBox |"
    echo -ne "\n${yellowColour}"
    printTable '_' "$(cat titles.table | tr '|' '_')"
    echo -ne "\n${endColour}"
}

function appendMAchines(){
  echo -e "HackTheBox | ${check_machines} [OSCP Style] (TWITCH LIVE) | [NO] " >> titles.table
  echo -e "name declare for machine apeend: ${check_machines}"

    echo -e "\n\n\t${redColour}[👑]${endColour}${grayColour} By: L44x ${endColour}"
    echo -e "\t${purpleColour}--------------------------------${endColour}"
    echo -e "\t${grayColour}>${endColour}${greenColour} Maquina: ${turquoiseColour} ${check_machines} ${endColour}${blueColour} agregado correctamente.${endColour} ${yellowColour}:)${endColour}"
    echo -e "\t${purpleColour}--------------------------------${endColour}\n\n"
  # HackTheBox | Datamynic [OSCP Style] (TWITCH LIVE)
}

function deleteMachine(){
  cat titles.table | grep -v "$delete_machine" > titles_temp.table
  rm titles.table
  mv titles_temp.table titles.table
  sleep 2; clear
#   echo -e "name declare for machine delete: ${delete_machine}"
        echo -e "\n\n\t${redColour}[!]${endColour}${grayColour} Uso: ./bash-scripting05.sh ${endColour}"
        echo -e "\t${purpleColour}--------------------------------${endColour}"
        echo -e "\t${grayColour}>${endColour}${redColour} Maquina: ${turquoiseColour} ${delete_machine} ${endColour}${blueColour} eliminado correctamente.${endColour} ${yellowColour}:)${endColour}"
        echo -e "\t${purpleColour}--------------------------------${endColour}\n\n"
}

function filterMachine(){
#   echo -e "name declare for machine filter: ${filter_machine}"
  # cat titles.table | grep "$filter_machine"
  sleep 2; clear

  echo -e "\t\t\t${greenColour} [!]${endColour}${yellowColour} Detalles de la maquina.${endColour}"
  echo -e "\t\t\t${purpleColour}---------------------------${endColour}"
  echo -e "${blueColour}"
  printTable '_' "$(cat titles.table | grep "$filter_machine" | tr '|' '_')"
  echo -ne "\n${endColour}"
}

function changeStatusMachine(){
    #sed -i 's/\(\[.*\]\)$/\[OSCP Style] (TWITCH LIVE) | \[NO\]/' titles.table
    sleep 1; clear
    echo -e "\n\t\t\t${greenColour}[!]${endColour}${yellowColour} Detalles de la maquina.${endColour}"
    echo -e "\t\t\t${purpleColour}---------------------------${endColour}"
    echo -e "${blueColour}"
    printTable '_' "$(cat titles.table | grep "$status_machine" | tr '|' '_')"
    echo -ne "\n${endColour}"
    # cat titles.table | grep "$status_machine" | sed 's/$/ [NO]/'

    echo -ne "\t${blueColour}>${endColour} ${grayColour}La maquina fue resulta y vista con exito?${endColour} ${greenColour}[YES]${endColour} ${redColour}[NO]${blueColour} : "; read -r opcion
    if [ "$opcion" == "YES" ];then
        sed -i "/$status_machine/s/\[.*\]/[OSCP Style] (TWITCH LIVE) | [YES]/" titles.table
        clear;
        echo -e "\t\t${purpleColour}     -----------------------------------${endColour}"
        echo -e "\t\t${greenColour}[${endColour}${yellowColour}*${endColour}${greenColour}]${endColour}${turquoiseColour} Cambios guardados exitosamente.${endColour}"
        echo -e "\t\t${purpleColour}-----------------------------------${endColour}"
        echo -e "\t\t\t${redColour}    [👑]${endColour}${grayColour} By: L44x ${endColour}"
    elif [ "$opcion" == "NO" ]; then
        sed -i "/$status_machine/s/\[.*\]/[OSCP Style] (TWITCH LIVE) | [NO]/" titles.table
    else
        echo -e "Nombre de estado incorrecto. :("
        exit 1
    fi
}

function get_machines_status_yes(){
    if [ "$status_yes_machine" == "YES" ];then
        echo -ne "\n${greenColour}"
        printTable '_' "$(cat titles.table | grep "$status_yes_machine" | tr '|' '_')"
        echo -ne "\n${endColour}\n"
    elif [ "$status_yes_machine" == "NO" ]; then
        echo -ne "\n${redColour}"
        printTable '_' "$(cat titles.table | grep "$status_yes_machine" | tr '|' '_')"
        echo -ne "\n${endColour}\n"
    else
        echo -e "\n\n\t${redColour}[!]${endColour}${grayColour} Uso: ./bash-scripting05.sh ${endColour}"
        echo -e "\t${purpleColour}--------------------------------${endColour}"
        echo -e "\t${grayColour}>${endColour}${greenColour} Nombre de estado incorrecto.${endColour} ${redColour}:(${endColour}"
        echo -e "\t${purpleColour}--------------------------------${endColour}\n\n"
        exit 1
    fi
}

# Parametros funcionales.
all_machines=""
check_machines=""
delete_machine=""
filter_machine=""

while getopts ":a:c:d:f:m:s:h" arg; do # Parameters.
    case $arg in
        a) all_machines=$OPTARG;;
        c) check_machines=$OPTARG;;
        d) delete_machine=$OPTARG;;
        f) filter_machine=$OPTARG;;
        m) status_machine=$OPTARG;;
        s) status_yes_machine=$OPTARG;;
        h) helpPanel;;
    esac
done

if [ "$(echo ${all_machines})" == "maquinas_activas" ]; then # ./script.sh -a maquinas_activas
    clear;getAllMachines
elif [ "$(echo ${check_machines})" ]; then  # ./script.sh -c {name_machine}
    clear;appendMAchines
elif [ "$(echo ${delete_machine})" ]; then  # ./script.sh -d {name_machine}
    clear;deleteMachine
elif [ "$(echo ${filter_machine})" ]; then  # ./script.sh -f {name_machine}
    clear;filterMachine
elif [ "$(echo ${status_machine})" ]; then  # ./script.sh -f {name_machine}
    clear;changeStatusMachine
elif [ "$(echo ${status_yes_machine})" ]; then  # ./script.sh -f {name_machine}
    clear;get_machines_status_yes
fi
