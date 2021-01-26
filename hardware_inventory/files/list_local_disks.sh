#!/bin/bash

trim() {
    local var="$*"
    # remove leading whitespace characters
    var="${var#"${var%%[![:space:]]*}"}"
    # remove trailing whitespace characters
    var="${var%"${var##*[![:space:]]}"}"
    printf '%s' "$var"
}

for i in $(ls /sys/block/*/device/model)
  do
    disk_model_ws=$(cat $i |sed 's/[[:blank:]]//g')
    disk_models_ws=$(echo ^\($(sed 's/[[:blank:]]//g' /tmp/disk_models | paste -sd '|')\)$)
    if [[ $disk_model_ws =~ $disk_models_ws ]]
      then
        prefix="/sys/block/"
        suffix="/device/model"
        disk=${i#$prefix}
        disk=${disk%$suffix}
        disk_model=$(cat $i)
        disk_model=$(trim "$disk_model")
        prefix="Disk /dev/"$disk": "
        disk_size=$(fdisk -l /dev/$disk 2>/dev/null |grep "$prefix" |cut -d',' -f1)
        disk_size=${disk_size#$prefix}
        echo $disk"|"$disk_model"|"$disk_size
    fi
  done
  
