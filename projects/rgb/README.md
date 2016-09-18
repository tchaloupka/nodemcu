Remote RGB LED
==============

This project is meant to remotelly set the RGB LED color through the provided REST API.
It contains wery simple HTTP request handler.

It is possible to enable animation between colors (using `animate` and `step` settings)

To set the color it is needed to call this HTTP request:

```
curl http://<node-ip-address>/api/color -d '{"r":255,"g":0,"b":0}'

```

To get the current color, call:
```
curl http://<node-ip-address>/api/color
```

# Parts used
|Part|Description|
|----|-----------|
|[D1 mini](http://www.wemos.cc/Products/d1_mini.html)|Wemos D1 mini|
|[RGB LED](http://www.wemos.cc/Products/ws2812b_rgb_shield.html)|WS2812B RGB Shield|

# Notes
* Shield uses pin 2 to control the LED but NodeMCU uses pin 4. So it's needed to reroute it.

![schema](https://github.com/tchaloupka/nodemcu/blob/master/images/rgb.png?raw=true)
