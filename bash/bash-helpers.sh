function welcome() {
    local upSeconds="$(/usr/bin/cut -d. -f1 /proc/uptime)"
    local secs=$((upSeconds%60))
    local mins=$((upSeconds/60%60))
    local hours=$((upSeconds/3600%24))
    local days=$((upSeconds/86400))
    local UPTIME=$(printf "%d days, %02dh%02dm%02ds" "$days" "$hours" "$mins" "$secs")

    # calculate rough CPU and GPU temperatures:
    local cpuTempC

    local gpuTempC

    cpuTempC=$(($(cat /sys/class/thermal/thermal_zone0/temp)/1000))
    gpuTempC=`nvidia-settings --display :0 -t -q 0/GPUCoreTemp`


    local df_out=()
    local line
    while read line; do
        df_out+=("$line")
    done < <(df -h /)

    local df_out_data=()
    local line_data
    while read line_data; do
        df_out_data+=("$line_data")
    done < <(df -h /data0)

    local df_out_data_one=()
    local line_data_one
    while read line_data_one; do
        df_out_data_one+=("$line_data_one")
    done < <(df -h /data1)

    local rst="$(tput sgr0)"
    local fgblk="${rst}$(tput setaf 0)" # Black - Regular
    local fgred="${rst}$(tput setaf 1)" # Red
    local fggrn="${rst}$(tput setaf 2)" # Green
    local fgylw="${rst}$(tput setaf 3)" # Yellow
    local fgblu="${rst}$(tput setaf 4)" # Blue
    local fgpur="${rst}$(tput setaf 5)" # Purple
    local fgcyn="${rst}$(tput setaf 6)" # Cyan
    local fgwht="${rst}$(tput setaf 7)" # White

    local bld="$(tput bold)"
    local bfgblk="${bld}$(tput setaf 0)"
    local bfgred="${bld}$(tput setaf 1)"
    local bfggrn="${bld}$(tput setaf 2)"
    local bfgylw="${bld}$(tput setaf 3)"
    local bfgblu="${bld}$(tput setaf 4)"
    local bfgpur="${bld}$(tput setaf 5)"
    local bfgcyn="${bld}$(tput setaf 6)"
    local bfgwht="${bld}$(tput setaf 7)"
    local out
    local i
    echo "${bfgylw}__________ .____     _______________  ___"
    echo "${bfgylw}\\______   \\|    |    \\_   _____/\\   \\/  /"
    echo "${bfgylw} |     ___/|    |     |    __)_  \\     /"
    echo "${bfgylw} |    |    |    |___  |        \\ /     \\"
    echo "${bfgylw} |____|    |_______ \\/_______  //___/\\  \\"
    echo "${bfgylw}                   \\/        \\/       \\_/"

    for i in {0..11} ; do
      case "$i" in
            0)
                out+="${fggrn}$(date +"%A, %e %B %Y, %r")"
                ;;
            1)
                out+="${fggrn}$(uname -srmo)"
                ;;
            3)
                out+="${fgylw}${df_out[0]}"
                ;;
            4)
                out+="${fgwht}${df_out[1]}"
                ;;
            5)
                out+="${fgwht}${df_out_data[1]}"
                ;;
            6)
                out+="${fgwht}${df_out_data_one[1]}"
                ;;
            7)
                out+="${fgred}Uptime.............: ${UPTIME}"
                ;;
            8)
                out+="${fgred}Memory.............: $(grep MemFree /proc/meminfo | awk {'print $2'}) kB (Free) / $(grep MemTotal /proc/meminfo | awk {'print $2'})kB (Total)"
                ;;
            9)
                out+="${fgred}Running Processes..: $(ps ax | wc -l | tr -d " ")"
                ;;
            10)
                out+="${fgred}IP Address.........: $(ip -4 addr show eno1 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')"
                ;;
            11)
                out+="Temperature........: CPU: $cpuTempC Degrees C GPU: $gpuTempC Degrees C"
                ;;

        esac
        out+="\n"
    done
    echo -e "\n$out${fgwht}"
}
