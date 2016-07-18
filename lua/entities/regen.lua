AddCSLuaFile()
resource.AddFile("vgui/ttt/sirlag_regeneration.png")

EQUIP_REGEN = 5984 -- Our unique value
HEATH_TO_REGEN = 50
TIME_FOR_REGEN = 30
REGEN_CHUNKS = 10

hook.Add( "InitPostEntity", "AddRegenToStore", function() 
       local Regen = {
              id = EQUIP_REGEN,
              loadout = false,
              type = "item_passive",
              material = "vgui/ttt/sirlag_regeneration.png",
              name = "Heath Regen",
              desc = "Passively Restores "..HEATH_TO_REGEN.."\n"
      }
      table.insert( EquipmentItems[ROLE_TRAITOR], Regen )
end)

hook.Add("TTTOrderedEquipment", "OrderedARegenItem", function(ply)
	if ply:HasEquipmentItem(EQUIP_REGEN) then
		if(ply.hasregen == false) then
			ply.hasregen = true
			timer.Create( "HeathRegenerationTimer", math.floor(TIME_FOR_REGEN / REGEN_CHUNKS), REGEN_CHUNKS, function()
				tempHealth = ply:Health() + math.floor(HEATH_TO_REGEN / REGEN_CHUNKS)
				if (tempHealth > ply:GetMaxHealth()) then	tempHealth = ply:GetMaxHealth()	end
				ply:SetHealth(tempHealth)
			end)
		end
	end 
end)

local function Resettin()
	for k,v in pairs(player.GetAll()) do
		v.hasregen = false
	end
end

hook.Add( "TTTPrepareRound", "ResetTheHeathRegenItemBeauseISuckAtThis", Resettin )