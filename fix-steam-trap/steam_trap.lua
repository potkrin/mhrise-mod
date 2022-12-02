local steam_trap_SteamElementTypeID = 0

function on_pre_createOtShell103(args)
    args[3] = sdk.to_ptr(steam_trap_SteamElementTypeID)
    return sdk.PreHookResult.CALL_ORIGINAL
end

function on_post_createOtShell103(retval)
   return retval
end

sdk.hook(sdk.find_type_definition("snow.shell.OtAirouShellManager"):get_method("createOtShell103"), 
	on_pre_createOtShell103,
	on_post_createOtShell103)


-- draw UI on ScriptGeneratedUI
local SteamElementTypeSelection = 1
local SteamElementType = {"Water", "Fire", "Ice"}

re.on_draw_ui(function()
	local changed = false
    changed, value = imgui.combo('SteamElement Type', SteamElementTypeSelection, SteamElementType)
    if changed then
        SteamElementTypeSelection = value
        if value == 2 then
            steam_trap_SteamElementTypeID = 1
        elseif value == 3 then
            steam_trap_SteamElementTypeID = 2
        else
            steam_trap_SteamElementTypeID = 0
        end
    end
end)