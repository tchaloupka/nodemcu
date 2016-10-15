BMP180 humidity and temperature sensor
=====================================

This project is meant to periodically send data to some REST service ([ubidots](https://www.ubidots.com/) is used in sample configuration).
It reads temperature and pressure from the BMP180 sensor.
It is made to use as less power as possible so it can use deep sleep feature (defined in settings and needing to connect D0 and RST pins to work).
If deep sleep is not used it disconnects from wifi and turns it off completely.

# Parts used
|Part|Description|
|----|-----------|
|[D1 mini](http://www.wemos.cc/Products/d1_mini.html)|Wemos D1 mini|
|[BMP180 shield](https://www.aliexpress.com/item/BMP180-Replace-BMP085-Digital-Barometric-Pressure-Sensor-Module-FOR-WeMos-D1-mini-WIFI-extension-board-learning/32706155315.html?ws_ab_test=searchweb0_0,searchweb201602_2_10065_10056_10068_10055_10054_10069_10059_10078_10079_10073_10017_10080_10070_10082_10081_421_420_10060_10061_10052_10062_10053_10050_10051,searchweb201603_3&btsid=fedd33db-44a2-4466-aaf4-a37edd2fd69e)|BMP180 sensor shield|

# Notes
* shield uses pins 1 and 2 to communicate with BMP180 sensor

