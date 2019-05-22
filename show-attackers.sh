#!/bin/bash

# Mostramos todas las IP's de syslog-sample y las guardamos en 'todas-ips.txt'
grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' $1 > todas-ips.txt

function pause(){
   read -p "$*"
}


# Inicializamos los contadores
countips=0;
file=$1;

# Contador ips es 17
ips=$(sort -u todas-ips.txt | wc -l)

# Contador logs es X
logs=$(cat syslog-sample | wc -l)

echo "Count,IP,Location"

# Empezamos el bucle para mostrar la info
while [ $countips -lt $ips ]; do

       	total=($(sort -u todas-ips.txt))
	ip=${total[$countips]}
    #echo "$ip"
	countipsfail=$(grep -o -c "Failed password for root from $ip" $file)
	countips=$(grep -o -c "$ip" syslog-sample)
    #echo "$countips"
	val=$(geoiplookup $ip)
	var=$(echo "$val" | cut -b 28-40 )
    #location=${val[$1]}
	echo "--------------------------------"
	echo "PUBLIC IP: $ip"
	echo "--------------------------------"
	echo " Times in file: $countips"
	echo " Times FAILED password root: $countipsfail"
	echo " LOCATION: $var"
# Guardamos 10 logs de los ataques
	if [ $countipsfailed -ge 10 ]; then
	echo "$countipsfailed,$ip,$var" >> show-all-ips
	fi
	countips=$[$countips+1];
done

	pause "Press Enter"
	clear
	echo "Count,Ip,Location"
	echo "-----------------"
# Las ordenamos
	sort -nr show-all-ips
rm show-all-ips
