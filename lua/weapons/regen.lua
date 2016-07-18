AddCSLuaFile()
resource.AddFile("vgui/ttt/sirlag_regeneration.png")

EQUIP_REGEN = 5984 		-- Make sure this is unique. Leaving it as is should be fine in almost all scenarios.
HEATH_TO_REGEN = 50		-- How much health to regenerate.
TIME_FOR_REGEN = 30		-- How Long (in seconds) it should take to regenerate the heath.
REGEN_CHUNKS = 10		-- How many ticks it takes to regenerate the health. This can be set to 1, which would
						-- regenerate all of the health after your TIME_FOR_REGEN is over.
						-- Setting it to 0 will throw major script errors. just don't do it.

--This is a hook to set up the addon in the traitor shop. There is also a line you can uncomment to add it to detective 
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
	  --Uncomment the next line to add the item to the detective shop as well.
	  --table.insert( EquipmentItems[ROLE_DETECTIVE], Regen )
end)

--Hooks buying the regen item from the traitor shop. After grabbing that, it starts the healing process.
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

-- This Hook makes sure that the regen item is removed from all players inventories.
hook.Add( "TTTPrepareRound", "ResetTheHeathRegenItemBeauseISuckAtThis", function()
 	for k,v in pairs(player.GetAll()) do
		 v.hasregen = false
	end
end )