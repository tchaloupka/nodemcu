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

function getSensorData()
    bmp085.init(sdaPin, sclPin)
    local t = bmp085.temperature()
    local p = bmp085.pressure()
    res = string.format('{"temp":%s,"press":%s}', t/10, p/100)
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
    tmr.alarm(0, 100, tmr.ALARM_AUTO, function() loop() end)
end

dofile("settings.lua")
init()

