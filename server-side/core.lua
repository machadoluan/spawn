local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
tvRP = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
NewYork = {}
Tunnel.bindInterface("spawn", NewYork)

local Global = {}

function NewYork.Characters()
	local Character = {}
	local source = source
	local License = vRP.Identities(source)
	local Consult = vRP.Query("characters/Characters", { license = License })

	TriggerEvent("vRP:BucketServer", source, "Enter", source)

	if Consult[1] then
		for _, v in pairs(Consult) do
			local Datatable = vRP.UserData(v["id"], "Datatable")
			if Datatable then
				table.insert(Character, {
					["Passport"] = v["id"],
					["Skin"] = Datatable["Skin"],
					["Nome"] = v["name"] .. " " .. v["name2"],
					["Sexo"] = v["sex"],
					["Banco"] = v["bank"],
					["Blood"] = Sanguine(v["blood"]),
					["Clothes"] = vRP.UserData(v["id"], "Clothings"),
					["Barber"] = vRP.UserData(v["id"], "Barbershop"),
					["Tattoos"] = vRP.UserData(v["id"], "Tatuagens")
				})
			end
		end
	end

	return Character
end

function NewYork.CharacterChosen(Passport)
	local source = source
	local license = vRP.Identities(source)
	local query = vRP.Query("characters/UserLicense", { id = Passport, license = license })
	if query and query[1] then
		TriggerEvent("vRP:BucketServer", source, "Exit")
		vRP.CharacterChosen(source, Passport)
		return true
	else
		DropPlayer(source, "Conectando em personagem irregular.")
	end
	return false
end

function NewYork.FinshSpawn()
	local source = source
	SetPlayerRoutingBucket(source, 0)
	tvRP.stopAnim(source, false)
end
