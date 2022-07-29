#!/bin/bash


# AirtagMQTT reads various metadata from Apple Airtags using the "Where is?" app on a mac and publishes its values via MQTT.

# You need: Mosquitto MQTT Client (brew install mosquitto), 

# Usage: airtag-mqtt -id '121212ED121212' -h <host> -p <port> -t '<topic>' -f <filename.csv>

# Based on: https://github.com/icepick3000/AirtagAlex



# Configuration


hostname='172.16.10.12'
mqtt_port=''
mqtt_user='mqtt'
mqtt_pass='mqtt'
mqtt_topic='airtag-mqtt/'
ha_autodiscovery='1'
csv_enabled='1'
csv_path='debug.csv'
delay='9'

RED='\033[0;31m'
NC='\033[0m' # No Color

show_splashscreen () {
    
    echo""
  printf "           Airtag${RED}MQTT${NC}Bridge\n"

    echo "----------------------------------------"
    echo "        * v0.1 - 2022-07-29 *           "
    echo "----------------------------------------"
    echo " apple airtag metadata -> MQTT bridge   "
    echo "           github.com/merlin077         " 
    echo "                                        "
#    .---------- constant part!
#    vvvv vvvv-- the code from above
    }
    

#Start an infinite loop
while :
do 

    show_splashscreen
	echo "Copying Items.data file..." 
    cp -pr ~/Library/Caches/com.apple.findmy.fmipcore/Items.data Items.data 
    echo "Success"
	echo "Check if CSV file exists..."
    if [ ! -f $csv_path ]
	then
	echo "Nope, file does not exist, creating it now!"
	
   # Header for the CSV file (currently set up to append to the file)
	echo datetime,name,serialnumber,producttype,productindentifier,vendoridentifier,antennapower,systemversion,batterystatus,locationpositiontype,locationlatitude,locationlongitude,locationtimestamp,locationverticalaccuracy,locationhorizontalaccuracy,locationfloorlevel,locationaltitude,locationisinaccurate,locationisold,locationfinished,addresslabel,addressstreetaddress,addresscountrycode,addressstatecode,addressadministrativearea,addressstreetname,addresslocality,addresscountry,addressareaofinteresta,addressareaofinterestb,batterystatus >> $csv_path
	fi
    echo "Written header..."
    
#    echo "Check if Airtagloki.csv exists"
#	if [ ! -f Airtagloki.csv ]
#	then
#	echo "Nope, Airtagloki.csv does not exist, creating it!"
	#Header for the CSV file (currently set up to append to the file)
	#echo #datetime,name,serialnumber,producttype,productindentifier,vendoridentifier,antennapower,systemversion,batterystatus,locationposi#tiontype,locationlatitude,locationlongitude,locationtimestamp,locationverticalaccuracy,locationhorizontalaccuracy,locationfloorl#evel,locationaltitude,locationisinaccurate,locationisold,locationfinished,addresslabel,addressstreetaddress,addresscountrycode,a#ddressstatecode,addressadministrativearea,addressstreetname,addresslocality,addresscountry,addressareaofinteresta,addressareaofi#nterestb,batterystatus >> Airtagloki.csv
	#fi
    #echo "Written header..."

    sleep 3
        clear && printf '\e[3J'
    show_splashscreen
	echo "Checking the number of Airtags to process..."
	airtagsnumber=`cat Items.data | jq ".[].serialNumber" | wc -l`
	echo "Airtags found: $airtagsnumber"
	airtagsnumber=`echo "$(($airtagsnumber-1))"`
    sleep 2
	for j in $(seq 0 $airtagsnumber)
	do

	echo Processing airtag $j with serial number $serialnumber

	datetime=`date +"%Y-%m-%d  %T"`

	serialnumber=`cat ~/Desktop/Airtags/Items.data | jq .[$j].serialNumber | tr -d '"'`
	name=`cat ~/Desktop/Airtags/Items.data | jq .[$j].name | tr -d '"'`
	producttype=`cat ~/Desktop/Airtags/Items.data | jq ".[$j].productType.type" | tr -d '"'`
	productindentifier=`cat ~/Desktop/Airtags/Items.data | jq ".[$j].productType.productInformation.productIdentifier"`
	vendoridentifier=`cat ~/Desktop/Airtags/Items.data | jq ".[$j].productType.productInformation.vendorIdentifier"`
	antennapower=`cat ~/Desktop/Airtags/Items.data | jq ".[$j].productType.productInformation.antennaPower"`
	systemversion=`cat ~/Desktop/Airtags/Items.data | jq ".[$j].systemVersion" | tr -d '"'`
	batterystatus=`cat ~/Desktop/Airtags/Items.data | jq ".[$j].batteryStatus"`
	locationpositiontype=`cat ~/Desktop/Airtags/Items.data | jq ".[$j].location.positionType" | tr -d '"'`
	locationlatitude=`cat ~/Desktop/Airtags/Items.data | jq ".[$j].location.latitude"`
	locationlongitude=`cat ~/Desktop/Airtags/Items.data | jq ".[$j].location.longitude"`
	locationtimestamp=`cat ~/Desktop/Airtags/Items.data | jq ".[$j].location.timeStamp"`
	locationverticalaccuracy=`cat ~/Desktop/Airtags/Items.data | jq ".[$j].location.verticalAccuracy" | sed 's/null/0/g'`
	locationhorizontalaccuracy=`cat ~/Desktop/Airtags/Items.data | jq ".[$j].location.horizontalAccuracy" | sed 's/null/0/g'`
	locationfloorlevel=`cat ~/Desktop/Airtags/Items.data | jq ".[$j].location.floorlevel" | sed 's/null/0/g'`
	locationaltitude=`cat ~/Desktop/Airtags/Items.data | jq ".[$j].location.altitude" | sed 's/null/0/g'`
	locationisinaccurate=`cat ~/Desktop/Airtags/Items.data | jq ".[$j].location.isInaccurate" | awk '{ print "\""$0"\"" } ' | tr -d '"'`
	locationisold=`cat ~/Desktop/Airtags/Items.data | jq ".[$j].location.isOld" | awk '{ print "\""$0"\"" }' | tr -d '"' `
	locationfinished=`cat ~/Desktop/Airtags/Items.data | jq ".[$j].location.locationFinished" | awk '{ print "\""$0"\"" }' | tr -d '"'`
	addresslabel=`cat ~/Desktop/Airtags/Items.data | jq ".[$j].address.label" | sed 's/null/""/g' | tr -d '"'`
	addressstreetaddress=`cat ~/Desktop/Airtags/Items.data | jq ".[$j].address.streetAddress"| sed 's/null/""/g' | tr -d '"'`
	addresscountrycode=`cat ~/Desktop/Airtags/Items.data | jq ".[$j].address.countryCode"| sed 's/null/""/g' | tr -d '"'`
	addressstatecode=`cat ~/Desktop/Airtags/Items.data | jq ".[$j].address.stateCode" | sed 's/null/""/g' | tr -d '"'`
	addressadministrativearea=`cat ~/Desktop/Airtags/Items.data | jq ".[$j].address.administrativeArea"| sed 's/null/""/g' | tr -d '"'`
	addressstreetname=`cat ~/Desktop/Airtags/Items.data | jq ".[$j].address.streetName"| sed 's/null/""/g' | tr -d '"'`
	addresslocality=`cat ~/Desktop/Airtags/Items.data | jq ".[$j].address.locality"| sed 's/null/""/g' | tr -d '"'`
	addresscountry=`cat ~/Desktop/Airtags/Items.data | jq ".[$j].address.country"| sed 's/null/""/g' | tr -d '"'`
	addressareaofinteresta=`cat ~/Desktop/Airtags/Items.data | jq ".[$j].address.areaOfInterest[0]" | sed 's/null/""/g' | tr -d '"'`
	addressareaofinterestb=`cat ~/Desktop/Airtags/Items.data | jq ".[$j].address.areaOfInterest[1]" | sed 's/null/""/g' | tr -d '"'`
	batterystatus=`cat ~/Desktop/Airtags/Items.data | jq ".[$j].batteryStatus"`

	echo "Writing CSV file to $csv_path ..."

	echo $datetime,$name,$serialnumber,$producttype,$productindentifier,$vendoridentifier,$antennapower,$systemversion,$batterystatus,$locationpositiontype,$locationlatitude,$locationlongitude,$locationtimestamp,$locationverticalaccuracy,$locationhorizontalaccuracy,$locationfloorlevel,$locationaltitude,$locationisinaccurate,$locationisold,$locationfinished,$addresslabel,$addressstreetaddress,$addresscountrycode,$addressstatecode,$addressadministrativearea,$addressstreetname,$addresslocality,$addresscountry,$addressareaofinteresta,$addressareaofinterestb,$batterystatus >> $csv_path
    echo "Publishing via MQTT: ${mqtt_topic}${serialnumber}/..."  
    
    mosquitto_pub -h ${hostname} -u mqtt -P mqtt -t ${mqtt_topic}${serialnumber}/datetime -m "${datetime}"
    mosquitto_pub -h ${hostname} -u mqtt -P mqtt -t ${mqtt_topic}${serialnumber}/name -m "${name}"
    mosquitto_pub -h ${hostname} -u mqtt -P mqtt -t ${mqtt_topic}${serialnumber}/serialnumber -m "${serialnumber}"
    mosquitto_pub -h ${hostname} -u mqtt -P mqtt -t ${mqtt_topic}${serialnumber}/producttype -m "${producttype}"
    mosquitto_pub -h ${hostname} -u mqtt -P mqtt -t ${mqtt_topic}${serialnumber}/productidentifier -m "${productidentifier}"
    
    mosquitto_pub -h ${hostname} -u mqtt -P mqtt -t ${mqtt_topic}${serialnumber}/vendoridentifier -m "${vendoridentifier}"
    mosquitto_pub -h ${hostname} -u mqtt -P mqtt -t ${mqtt_topic}${serialnumber}/antennapower -m "${antennapower}"
    mosquitto_pub -h ${hostname} -u mqtt -P mqtt -t ${mqtt_topic}${serialnumber}/systemversion -m "${systemversion}"
    mosquitto_pub -h ${hostname} -u mqtt -P mqtt -t ${mqtt_topic}${serialnumber}/batterystatus -m "${batterystatus}"
    mosquitto_pub -h ${hostname} -u mqtt -P mqtt -t ${mqtt_topic}${serialnumber}/locationpositiontype -m "${locationpositiontype}"
    
    mosquitto_pub -h ${hostname} -u mqtt -P mqtt -t ${mqtt_topic}${serialnumber}/locationlatitude -m "${locationlatitude}"
    mosquitto_pub -h ${hostname} -u mqtt -P mqtt -t ${mqtt_topic}${serialnumber}/locationlongitude -m "${locationlongitude}"
    mosquitto_pub -h ${hostname} -u mqtt -P mqtt -t ${mqtt_topic}${serialnumber}/locationtimestamp -m "${locationtimestamp}"
    mosquitto_pub -h ${hostname} -u mqtt -P mqtt -t ${mqtt_topic}${serialnumber}/locationverticalaccuracy -m "${locationverticalaccuracy}"
    mosquitto_pub -h ${hostname} -u mqtt -P mqtt -t ${mqtt_topic}${serialnumber}/locationhorizontalaccuracy -m "${locationhorizontalaccuracy}"
    
    mosquitto_pub -h ${hostname} -u mqtt -P mqtt -t ${mqtt_topic}${serialnumber}/locationfloorlevel -m "${locationfloorlevel}"
    mosquitto_pub -h ${hostname} -u mqtt -P mqtt -t ${mqtt_topic}${serialnumber}/locationaltitude -m "${locationaltitude}"
    mosquitto_pub -h ${hostname} -u mqtt -P mqtt -t ${mqtt_topic}${serialnumber}/locationisinaccurate -m "${locationisinaccurate}"
    mosquitto_pub -h ${hostname} -u mqtt -P mqtt -t ${mqtt_topic}${serialnumber}/locationisold -m "${locationisold}"
    mosquitto_pub -h ${hostname} -u mqtt -P mqtt -t ${mqtt_topic}${serialnumber}/locationfinished -m "${locationfinished}"
    
    mosquitto_pub -h ${hostname} -u mqtt -P mqtt -t ${mqtt_topic}${serialnumber}/addresslabel -m "${addresslabel}"
    mosquitto_pub -h ${hostname} -u mqtt -P mqtt -t ${mqtt_topic}${serialnumber}/addressstreetaddress -m "${addressstreetaddress}"
    mosquitto_pub -h ${hostname} -u mqtt -P mqtt -t ${mqtt_topic}${serialnumber}/addresscountrycode -m "${addresscountrycode}"
    mosquitto_pub -h ${hostname} -u mqtt -P mqtt -t ${mqtt_topic}${serialnumber}/addressstatecode -m "${addressstatecode}"
    mosquitto_pub -h ${hostname} -u mqtt -P mqtt -t ${mqtt_topic}${serialnumber}/addressadministrativearea -m "${addressadministrativearea}"
    
    mosquitto_pub -h ${hostname} -u mqtt -P mqtt -t ${mqtt_topic}${serialnumber}/addressstreetname -m "${addressstreetname}"
    mosquitto_pub -h ${hostname} -u mqtt -P mqtt -t ${mqtt_topic}${serialnumber}/addresslocality -m "${addresslocality}"
    mosquitto_pub -h ${hostname} -u mqtt -P mqtt -t ${mqtt_topic}${serialnumber}/addresscountry -m "${addresscountry}"
    mosquitto_pub -h ${hostname} -u mqtt -P mqtt -t ${mqtt_topic}${serialnumber}/addressareaofinteresta -m "${addressareaofinteresta}"
    mosquitto_pub -h ${hostname} -u mqtt -P mqtt -t ${mqtt_topic}${serialnumber}/addressareaofinterestb -m "${addressareaofinterestab}"
    mosquitto_pub -h ${hostname} -u mqtt -P mqtt -t ${mqtt_topic}${serialnumber}/batterystatus -m "${batterystatus}"
    echo "Success!"
    echo ""

    done
  shift
  msg=$@
  while [ $delay -gt 0 ]
  do
    printf "\r\033[KWaiting %.d second(s) before next update$msg" $((delay--))
    sleep 1
  done
  echo
done