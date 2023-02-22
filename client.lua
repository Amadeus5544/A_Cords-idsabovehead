local showCoords = false

-- Függvény, amely a játékos koordinátáit adja vissza
function getPlayerLocation()
    local playerPed = GetPlayerPed(-1)
    local playerCoords = GetEntityCoords(playerPed)
    return playerCoords
end

-- Koordináták folyamatos kiíratása az ekranra
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if showCoords then
            local playerCoords = getPlayerLocation()
            drawTxt(1, 0.5, 1.0,1.0,0.4, "x: " .. playerCoords.x .. ", y: " .. playerCoords.y .. ", z: " .. playerCoords.z, 255, 255, 255, 255)
        end
    end
end)

-- Funkció, amely lehetővé teszi a szöveg kiírását az ekranra
function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropshadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

-- Parancskezelés a koordináták ki- és bekapcsolásához
RegisterCommand("coords", function()
    showCoords = not showCoords
end)

-----



Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for _, player in ipairs(GetActivePlayers()) do
            if NetworkIsPlayerActive(player) then
                local ped = GetPlayerPed(player)
                local coords = GetEntityCoords(ped)
                local distance = #(GetEntityCoords(PlayerPedId()) - coords)
                if distance < 50 then
                    local playerID = GetPlayerServerId(player)
                    local steamName = GetPlayerName(player)
                    local formattedText = string.format("%d (%s)", playerID, steamName)
                    DrawText3D(coords.x, coords.y, coords.z + 1.2, formattedText)
                end
            end
        end
    end
end)

function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local scale = 0.3
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

    if onScreen then
        SetTextScale(scale, scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end