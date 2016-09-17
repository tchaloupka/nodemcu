DHT22 humidity and temperature sensor
=====================================

This project is meant to periodically send data to some REST service ([ubidots](https://www.ubidots.com/) is used in sample configuration).
It reads humidity, temperature and VCC.
It is made to use as less power as possible so it can use deep sleep feature (defined in settings and needing to connect D0 and RST pins to work).
If deep sleep is not used it disconnects from wifi and turns it off completely.

# Parts used
|Part|Description|
|----|-----------|
|[D1 mini](http://www.wemos.cc/Products/d1_mini.html)|Wemos D1 mini|
|[DHT Pro shield](http://www.wemos.cc/Products/dht_pro_shield.html)|DHT sensor shield|

# Notes
* shield uses pin 4 to communicate with DHT sensor
* don't use DHT11, it's not worth the cheaper price..

