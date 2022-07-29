# AirtagMQTT

Based on the work of https://github.com/icepick3000/AirtagAlex/

AirtagMQTT fetches metadata from within the "Where is?" app on a Mac. This data is parsed and then published via MQTT.
The location information can now be processed by software like Home Assistant which updates the location on the map and provides historical data visualization.

Requirements: mosquitto (Mac: 'brew install mosquitto')
Usage: ./airtag-mqtt.sh

Configuration: open the file with a text editor and customize the configuration variables on the top.
