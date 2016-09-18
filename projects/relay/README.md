Remote relay
============

This project is meant to set relay On/Off as requested through the provided REST API.
It contains wery simple HTTP request handler.

To turn the relay on or off it is needed to call this HTTP request:

```
curl http://<node-ip-address>/api/relay -d "set=<on/off>"

```

To check current relay status just call:
```
curl http://<node-ip-address>/api/relay
```

# Parts used
|Part|Description|
|----|-----------|
|[D1 mini](http://www.wemos.cc/Products/d1_mini.html)|Wemos D1 mini|
|[relay](http://www.wemos.cc/Products/relay_shield_v2.html)|relay shield v2|
|220R|resistor|
|led|some LED to test with|

# Notes
* shield uses pin 1 to control relay

![schema](https://github.com/tchaloupka/nodemcu/blob/master/images/relay.png?raw=true)
