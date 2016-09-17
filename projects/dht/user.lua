function wifiConnect()
    -- Connect to the wifi network
    print("wifi on")
    wifi.setmode(wifi.STATION)
    wifi.setphymode(wifi_signal_mode)
    wifi.sta.config(wifi_SSID, wifi_password)
    wifi.sta.connect()
    if client_ip ~= "" then
        wifi.sta.setip({ip=client_ip,netmask=client_netmask,gateway=client_gateway})
    end
end

function wifiDisconnect()
    print("wifi off")
    wifi.sta.disconnect()
    wifi.setmode(wifi.NULLMODE)
    --wifi.sleeptype(wifi.MODEM_SLEEP)
end

function getDht()
    res = ""
    status, temp, humi, temp_dec, humi_dec = dht.read(dhtPin)
    if status == dht.OK then
        print("DHT OK")
        -- Integer firmware using this example
        --res = string.format('"temp":%d.%03d,"hum":%d.%03d',
        --      math.floor(temp),
        --      temp_dec,
        --      math.floor(humi),
        --      humi_dec
        --)
        -- Float firmware using this example
        res = '"temp":'..temp..',"hum":'..humi
    elseif status == dht.ERROR_CHECKSUM then
        print( "DHT Checksum error." )
    elseif status == dht.ERROR_TIMEOUT then
        print( "DHT timed out." )
    end
    return res
end

function getVcc()
    return '"vcc":'..adc.readvdd33()/1000
end

function getSensorData()
    res = string.format('{%s,%s}', getVcc(), getDht())
    print(res)
    return res
end

function loop()
    if wifi.sta.status() == 5 then
        tmr.unregister(0) -- Stop the loop
        print("Acquired IP: "..wifi.sta.getip())
        print("Sending request to: "..server_uri)
        http.post(server_uri,
            'Content-Type: application/json\r\n',
            getSensorData(),
            function(code, data)
                if (code < 0) then
                  print("HTTP request failed")
                else
                  print(code, data)
                end
                if (deep_sleep == 1) then
                    print("Going to deep sleep for "..(time_between_sensor_readings/1000).." seconds")
                    node.dsleep(time_between_sensor_readings*1000)
                else
                    wifiDisconnect()
                    tmr.alarm(0, time_between_sensor_readings, tmr.ALARM_SINGLE, function() init() end)
                end
            end
        )
    else
        print("Connecting...")
    end
end

function init()
    wifiConnect()
    getDht() -- to read twice as noted on shield specs
    tmr.alarm(0, 100, tmr.ALARM_AUTO, function() loop() end)
end

dofile("settings.lua")
init()
