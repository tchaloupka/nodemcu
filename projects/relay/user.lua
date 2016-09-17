function setupWifi()
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

function setupRelay()
    gpio.mode(relayPin, gpio.OUTPUT)
end

relayState = 0
function setupListener()
    local function loop()
        if wifi.sta.getip() == nil then
            print("Connecting...")
        else
            tmr.unregister(0) -- Stop the loop
            print("Acquired IP: "..wifi.sta.getip())
            sv = net.createServer(net.TCP, 30)
            sv:listen(80, function(c)
                c:on("receive", function(c, pl)
                    --print(pl)
                    req = get_http_req(pl)
                    if (req["METHOD"] == "POST" and req["REQUEST"] == "/api/relay") then
                        print("Relay -> "..(req["MSGBODY"] == "set=on" and "ON" or "OFF"))
                        gpio.write(relayPin, req["MSGBODY"] == "set=on" and gpio.HIGH or gpio.LOW)
                        relayState = req["MSGBODY"] == "set=on" and 1 or 0
                        c:send("HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nConnection: close\r\n\r\n"..(relayState == 0 and "off" or "on"))
                    elseif (req["METHOD"] == "GET" and req["REQUEST"] == "/api/relay") then
                        c:send("HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nConnection: close\r\n\r\n"..(relayState == 0 and "off" or "on"))
                    else
                        c:send("HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nConnection: close\r\n\nCall POST request to /api/relay with set=on or set=off as data")
                    end
                    c:close()
                end)
            end)
        end
    end

    tmr.alarm(0, 1000, tmr.ALARM_AUTO, function() loop() end)
end

-- Build and return a table of the http request data
function get_http_req (instr)
    local t = {}
    local first = nil
    local strt_ndx, end_ndx, c1, c2, c3

    strt_ndx, end_ndx, c1 = string.find(instr,"\r\n\r\n(.*)$")
    if (strt_ndx ~= nil) then
        t["MSGBODY"] = trim(c1)
        instr = string.sub(instr, 1, strt_ndx - 1)
    end

    for str in string.gmatch (instr, "([^\n]+)") do
        -- First line is the method and path
        if (first == nil) then
            first = 1
            strt_ndx, end_ndx, c1, c2, c3 = string.find(str,"(.+) (.+) (.+)")
            t["METHOD"] = c1
            t["REQUEST"] = c2
            t["HTTPVER"] = c3
        else -- Process and reamaining ":" fields
            strt_ndx, end_ndx, c1, c2 = string.find (str, "([^:]+): (.+)")
            if (strt_ndx ~= nil) then
                t[c1] = c2
            end
        end
    end

    return t
end

-- String trim left and right
function trim (s)
    return (s:gsub ("^%s*(.-)%s*$", "%1"))
end

dofile("settings.lua")
setupRelay()
setupWifi()
setupListener()
