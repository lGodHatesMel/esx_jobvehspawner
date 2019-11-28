ESX = nil

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
    PlayerData = ESX.GetPlayerData()
  end
end)

local polVehicle =  nil

function polVehicleS(vehicletype)
  local playerPed = PlayerPedId()
  local PedPosition = GetEntityCoords(playerPed)
  ESX.Game.SpawnVehicle(vehicletype, {
    x = PedPosition.x,
    y = PedPosition.y,
    z = PedPosition.z
  },120, function(callback_vehicle)
    polVehicle = callback_vehicle
    local vehicle = GetVehiclePedIsIn(PlayerPed, true)
    SetVehicleUndriveable(polVehicle, false)
    SetVehicleEngineOn(polVehicle, true, true)
    while not polVehicle do Citizen.Wait(100) end;
    PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", 1)
    TaskWarpPedIntoVehicle(playerPed, polVehicle, -1)
  end)
end

RegisterCommand("sv", function(source, args, rawCommand)
  local vehicletype = table.concat(args, " ")
  local xPlayer = ESX.GetPlayerData()
  local job = xPlayer.job
  local jobname = xPlayer.job.name
  if job and jobname == 'police' or job and jobname == 'ambulance' then
    polVehicleS(vehicletype)
  end
end)
