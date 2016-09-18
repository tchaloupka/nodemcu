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

function setupLed()
    ws2812.init(mode)
    setColor({r=0, g=0, b=0})
end

targetColor = nil
sourceColor = nil
colorSteps = nil
currentStep = nil
function setColor(color)
    print("Color -> "..color["r"]..","..color["g"]..","..color["b"])
    targetColor = color;
    if (sourceColor == nil or animate == 0) then
        sourceColor = color;
        ws2812.write(string.char(color["g"], color["r"], color["b"]))
    else
        colorSteps = {(targetColor["r"]-sourceColor["r"])/animate,
            (targetColor["g"]-sourceColor["g"])/animate,
            (targetColor["b"]-sourceColor["b"])/animate}
        --print("AnimateSteps -> "..colorSteps[1]..","..colorSteps[2]..","..colorSteps[3])
        currentStep = 0
        tmr.alarm(0, step, tmr.ALARM_AUTO, function()
                currentStep = currentStep + 1
                local color = {}
                if (currentStep == animate) then
                    tmr.stop(0)
                    color = targetColor
                    sourceColor = targetColor
                else
                    color["r"] = math.floor(sourceColor["r"] + colorSteps[1] * currentStep)
                    color["g"] = math.floor(sourceColor["g"] + colorSteps[2] * currentStep)
                    color["b"] = math.floor(sourceColor["b"] + colorSteps[3] * currentStep)
                end
                --print("AnimateColor -> "..color["r"]..","..color["g"]..","..color["b"])
                ws2812.write(string.char(color["g"], color["r"], color["b"]))
            end)
    end
end

function getColor()
    return cjson.encode(targetColor)
end

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
                    if (req["METHOD"] == "POST" and req["REQUEST"] == "/api/color") then
                        setColor(cjson.decode(req["MSGBODY"]))
                        c:send("HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nContent-Type: application/json\r\nConnection: close\r\n\r\n"..getColor())
                    elseif (req["METHOD"] == "GET" and req["REQUEST"] == "/api/color") then
                        c:send("HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nContent-Type: application/json\r\nConnection: close\r\n\r\n"..getColor())
                    else
                        c:send("HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nConnection: close\r\n\nCall POST request to /api/color with set=on or set=off as data")
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
setupLed()
setupWifi()
setupListener()

