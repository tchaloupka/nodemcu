NodeMCU playground
==================

This repository contains just some simple projects using [NodeMCU](http://nodemcu.com/index_en.html) as a platform.

My favourite devices are [wemos D1 mini](http://www.wemos.cc/Products/d1_mini.html) based on [esp8266ex](http://www.espressif.com/en/products/hardware/esp8266ex)
They are great to play with and cheap to get.

Usefull references:
* [Coud building service](http://nodemcu-build.com/) to build custom firmwares (using float version)
* [esptool.py](https://github.com/themadinventor/esptool) to flash the firmware into the device
* [ESPlorer](https://github.com/4refr0nt/ESPlorer) for skatch writing and uploading
* [NodeMCU documentation](https://nodemcu.readthedocs.io/en/master/)

# Projects:
| Directory | Description                                         |
| --------- | ----------------------------------------------------|
|    dht    | Simple temperature and humidity sensor using DHT22  |
|  button   | Simple event sending based on button state change   |
|   relay   | Relay controlled by web requests                    |
|    rgb    | RGB LED controlled by web requests                  |
|  bmp180   | Simple temperature and pressure sensor using BMP180 |

# Flashing firmware
* generate the firmware selecting required modules
* execute `esptool.py --port <serial port of ESP8266> write_flash -fs 32m 0x00000 <nodemcu-firmware>.bin`

It should output something like:
```
esptool.py v1.2-dev
Connecting...
Running Cesanta flasher stub...
Flash params set to 0x0040
Writing 471040 @ 0x0... 471040 (100 %)
Wrote 471040 bytes at 0x0 in 40.6 seconds (92.8 kbit/s)...
Leaving...
```

NodeMCU should output something like this after startup:
```
NodeMCU custom build by frightanic.com
	branch: master
	commit: 98d3b46e2c11068f361154a564ce75a048c9dadc
	SSL: false
	modules: adc,bit,cjson,dht,file,gpio,http,i2c,net,node,spi,tmr,uart,wifi
 build 	built on: 2016-08-20 10:54
 powered by Lua 5.1.4 on SDK 1.5.4.1(39cb9a32)
```

# Notes
* default baud rate is 115200

