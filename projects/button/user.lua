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

function sendEvent(level)
    if wifi.sta.status() == 5 then
        data = string.format('{"status",%s}', gpio.read(btnPin) == gpio.HIGH and 0 or 1)
        print("Sending request to: "..server_uri..", data: "..data)
        http.post(server_uri,
            'Content-Type: application/json\r\n',
            data,
            function(code, data)
                if (code < 0) then
                  print("HTTP request failed")
                else
                  print(code, data)
                end
            end
        )
    else
        print("Offline...")
    end
end

last = 0
function debounce(level)  
    local delay = 50 * 1000 -- 50ms * 1000 as tmr.now() has μs resolution

    local now = tmr.now()
    local delta = now - last
    if delta < 0 then delta = delta + 2147483647 end; -- because of delta rolling over
    --print("Got "..level..", delay: "..delta)
    if delta < delay then return end;

    last = now
    sendEvent()
end

function setupBtn()
    gpio.mode(btnPin, gpio.INT, gpio.PULLUP)
    gpio.trig(btnPin, "both", debounce)
end

dofile("settings.lua")
setupBtn()
wifiConnect()

