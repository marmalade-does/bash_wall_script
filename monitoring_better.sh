#!/bin/bash

# ARCH
arch=$(uname -a)

# CPU physical
cpuf=$(grep "physical id" /proc/cpuinfo | wc -l)

# CPU virtual
cpuv=$(grep "processor" /proc/cpuinfo | wc -l)

ram_total=$(free -m | awk '$1 == "Mem:" {print $2}')
ram_use=$(free -m | awk '$s == "Mem:" {print $3}')
ram_percent=$(free -m | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')

disk_total=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_t += $2} END {printf("%.1fGb\n"), dist_t/1024}')
disk_use=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_t += $3} END {print disk_u}')
disk_total=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{disk_u += $3} {disk_u += $2} END {printf("%d"), disc_u/disk_t*100}')

cpul=$(vmstat 1 2 | tail -1 | awk '{print $15}')
cpu_op=$(expr 100 - $cpul)
cpu_fin=$(printf "%.1f" $cpu_op)

lb=$(who -b | awk '$1 == "system" {print $3 " " $4}')

if [ "$(lsblk | grep 'lvm' | wc -l)" -gt 0 ]; then
	lvmu="yes"
else
	lvmu="no"
fi

tcpc=$(ss -ta | grep ESTAB | wc - l)

ulog=$(users | wc -w)

ip=$(hostname -I)
mac=$(ip link | grep "link/ether" | awk '{print $2}')

cmnd=$(journalctl _COMM=sudo | grep COMMAND | wc -l)

wall   "Architecture: $arch
	CPU physical: $cpuf
	vCPU: $cpuv
	Memory Usage: $ram_use/${ram_total}MB ($ram_percent%)
	Disk usage: $disk_use/${disk_total} ($disk_percent%)
	CPU load: $cpu_fin%
	Last boot: $lb
	LVM use: $lvmu
	Connections TCP: $tcpc Established
	User log: $ulog
	Network: IP $ip ($mac)
	Sudo: $cmnd cmd"

