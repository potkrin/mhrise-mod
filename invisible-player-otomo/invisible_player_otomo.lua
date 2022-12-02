log.info("[invisible-player-otomo.lua] started loading")

local invisible_player = true
local invisible_otomo = true

re.on_application_entry("PrepareRendering", function()
    local otomoManager = sdk.get_managed_singleton("snow.otomo.OtomoManager")
    if not otomoManager then return end

    local playerManager = sdk.get_managed_singleton("snow.player.PlayerManager")
    if not playerManager then return end

    local master = playerManager:call("findMasterPlayer")
    if not master then return end

    if invisible_player then
        local player = playerManager:call("getPlayer", 0)
        if player then
            player:call("get_GameObject"):call("set_DrawSelf", false)
        end
    end
        
    if invisible_otomo then
        for i = 0, 1 do
            local otomo = otomoManager:call("getOtomo", 0+4*i)
            if otomo then
                otomo:call("get_GameObject"):call("set_DrawSelf", false)
            end
        end
    end
end)

re.on_draw_ui(function()
	local changed = false
	if imgui.tree_node("Invisible Player&Otomo") then   
		changed, invisible_player = imgui.checkbox("Invisible Player", invisible_player)
		changed, invisible_otomo = imgui.checkbox("Invisible Otomo", invisible_otomo)
	end 
end)

log.info("[invisible_player_otomo.lua] finished loading")