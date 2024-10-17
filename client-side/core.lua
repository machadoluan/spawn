-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("spawn")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Camera = nil
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANIMS
-----------------------------------------------------------------------------------------------------------------------------------------
local Anims = {
	{ ["Dict"] = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", ["Name"] = "hi_dance_crowd_17_v2_male^2" },
	{ ["Dict"] = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@",      ["Name"] = "high_center_down" },
	{ ["Dict"] = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@",    ["Name"] = "med_center_up" }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWN:OPENED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("spawn:Opened")
AddEventHandler("spawn:Opened", function()
	local Ped = PlayerPedId()
	SetEntityCoords(Ped, -2066.34, -1025.09, 10.90, false, false, false, false)
	LocalPlayer["state"]:set("Invincible", true, true)
	LocalPlayer["state"]:set("Invisible", true, true)
	SetEntityVisible(Ped, false, false)
	FreezeEntityPosition(Ped, true)
	SetEntityInvincible(Ped, true)
	SetEntityHealth(Ped, 101)
	SetPedArmour(Ped, 0)
	Camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
	SetCamCoord(Camera, -2067.61, -1022.5, 11.91)
	RenderScriptCams(true, true, 0, true, true)
	SetCamRot(Camera, 0.0, 0.0, 184.26, 2)
	SetCamActive(Camera, true)
	Characters = vSERVER.Characters()
	if parseInt(#Characters) > 0 then
		Customization(Characters[1])
	end

	Wait(5000)

	SendNUIMessage({ Action = "Spawn", Table = Characters })
	SetNuiFocus(true, true)

	if IsScreenFadedOut() then
		DoScreenFadeIn(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHARACTERCHOSEN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("CharacterChosen", function(Data, Callback)
	if vSERVER.CharacterChosen(Data["Passport"]) then
		SendNUIMessage({ Action = "Close" })
	end

	vSERVER.FinshSpawn()
	Callback("Ok")
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- spawn:justSpawn
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("spawn:justSpawn")
AddEventHandler("spawn:justSpawn", function()
	SetEntityVisible(PlayerPedId(), true, false)
	LocalPlayer["state"]:set("Invisible", false, true)
	SendNUIMessage({ Action = "Close" })
	TriggerEvent("hud:Active", true)
	SetNuiFocus(false, false)

	if DoesCamExist(Camera) then
		RenderScriptCams(false, false, 0, false, false)
		SetCamActive(Camera, false)
		DestroyCam(Camera, false)
		Camera = nil
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CUSTOMIZATION
-----------------------------------------------------------------------------------------------------------------------------------------
function Customization(Table, Check)
	if not Table["Skin"] then
		Table["Skin"] = "mp_m_freemode_01"
	end

	if LoadModel(Table["Skin"]) then
		if Check then
			if GetEntityModel(PlayerPedId()) ~= GetHashKey(Table["Skin"]) then
				SetPlayerModel(PlayerId(), Table["Skin"])
				SetPedComponentVariation(PlayerPedId(), 5, 0, 0, 1)
			end
		else
			SetPlayerModel(PlayerId(), Table["Skin"])
			SetPedComponentVariation(PlayerPedId(), 5, 0, 0, 1)
		end

		local Ped = PlayerPedId()
		local Random = math.random(#Anims)
		if LoadAnim(Anims[Random]["Dict"]) then
			TaskPlayAnim(Ped, Anims[Random]["Dict"], Anims[Random]["Name"], 8.0, 8.0, -1, 1, 0, 0, 0, 0)
		end

		exports["skinshop"]:Apply(Table["Clothes"], Ped)
		exports["barbershop"]:Apply(Table["Barber"], Ped)

		for Index, Overlay in pairs(Table["Tattoos"]) do
			AddPedDecorationFromHashes(Ped, Overlay, Index)
		end

		SetEntityVisible(Ped, true, false)
		LocalPlayer["state"]:set("Invisible", false, true)
	end
end
