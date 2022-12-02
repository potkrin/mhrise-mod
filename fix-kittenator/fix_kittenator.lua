-- fix_kittenator.lua : written by hotkrin
-- fix result of Lottery Box to Kittenator

local Kittenator = true

-- return sdk.to_ptr(true) to fix the result to Kittenator
-- return sdk.to_ptr(false) to fix the result to fail(not kittenator and can have other skills)
function on_pre_lotRareSupport(args)
    return sdk.PreHookResult.CALL_ORIGINAL
end

function on_post_lotRareSupport(retval)
    return sdk.to_ptr(Kittenator)
end

sdk.hook(sdk.find_type_definition("snow.otomo.OtomoQuestAirou"):get_method("lotRareSupport"), 
	on_pre_lotRareSupport,
	on_post_lotRareSupport)

re.on_draw_ui(function()
	local changed = false
    changed, value = imgui.checkbox("Fix Kittenator", Kittenator)
    if changed then
        log.debug("value = "..tostring(value))
        Kittenator = value
    end
end)



-- -- lotRandomSupport() is called when the lotRareResult() returned false.
-- -- when the lotRareResult() failed, it means the result of Lottery Box is not kittenator(AirouDrangonator/ネコ式撃龍槍)
-- -- then, lotRandomSupport() will be called.
-- -- if you want to fix the result of lotRandomSupport() you have to make an instance of SupportAction and return it.
-- function on_pre_lotRandomSupport(args)
--     log.debug("on_pre_lotRandomSupport")
--     return sdk.PreHookResult.CALL_ORIGINAL
-- end

-- function on_post_lotRandomSupport(retval)
--     log.debug("on_post_lotRandomSupport:---- ")
--     return retval
-- end

-- sdk.hook(sdk.find_type_definition("snow.otomo.OtomoQuestAirou"):get_method("lotRandomSupport"), 
-- 	on_pre_lotRandomSupport,
-- 	on_post_lotRandomSupport)

