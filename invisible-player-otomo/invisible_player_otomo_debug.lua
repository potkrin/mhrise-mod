log.info("[inisible-player-otomo.lua] started loading")

re.on_application_entry("PrepareRendering", function()
    local otomoManager = sdk.get_managed_singleton("snow.otomo.otomoManagerager")
    if not otomoManager then return end

    local playerManager = sdk.get_managed_singleton("snow.player.PlayerManager")
    if not playerManager then return end

    -- local questManager = sdk.get_managed_singleton("snow.questManagerager")
    -- if not questManager then return end

    local master = playerManager:call("findMasterPlayer")
    if not master then return end


    -- -- disable light [[can set to DrawSelf=false but can't disable drawing light]]
    -- local flight = playerManager:get_field("_Flashlight")
    -- local draw_res = flight:call("get_DrawSelf")
    -- log.debug("draw_res: "..tostring(draw_res))
    -- flight:call("set_DrawSelf", false)
    -- draw_res = flight:call("get_DrawSelf")
    -- log.debug("after: draw_res: "..tostring(draw_res))
 
    local player = playerManager:call("getPlayer", 0)
    if player then
        player:call("get_GameObject"):call("set_DrawSelf", false)
    end
     
    for i = 0, 1 do
        local otomo = otomoManager:call("getOtomo", 0+4*i)
        if otomo then
            otomo:call("get_GameObject"):call("set_DrawSelf", false)
       end
    end
end)

log.info("[inisible_player_otomo.lua] finished loading")

