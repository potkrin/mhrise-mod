-- fix_teostra_mode.lua : written by hotkrin
-- fix the first Teostra's unique aura mode to Flame or Blast
-- this mod doesn't affect to 2nd, 3rd and latter aura

-- how to find:
--    DeveloperTools -> ObjectExplorer -> Types: Search "Em027"

-- get_CurrentMode()
--     return: snow.enemy.em027.Em027Define.UniqueMode
--
-- snow.enemy.em027.Em027Define.UniqueMode:
--     0: Flame
--     1: Blast

local TeostraUniqueModeID = 0
local SetInitTeostraMode = false

-- called on every mode change. not only called on unique mode change
function on_pre_updateMode(args)
    if SetInitTeostraMode then
        local em027character_base = sdk.to_managed_object(args[2])
        em027character_base:call('set_CurrentMode', TeostraUniqueModeID)
        SetInitTeostraMode = false
    end
    return sdk.PreHookResult.CALL_ORIGINAL
end

function on_post_updateMode(retval)
   return retval
end

-- hook on teostra
sdk.hook(sdk.find_type_definition("snow.enemy.em027.Em027CharacterBase"):get_method("updateMode"), 
	on_pre_updateMode,
	on_post_updateMode)

-- also hook on risen teostra
sdk.hook(sdk.find_type_definition("snow.enemy.em027.Em027_08Character"):get_method("updateMode"), 
	on_pre_updateMode,
	on_post_updateMode)


function on_pre_doStart(args)
    -- reset the SetInitTeostraMode flag
    SetInitTeostraMode = true
    return sdk.PreHookResult.CALL_ORIGINAL
end

function on_post_doStart(retval)
    return retval
end

-- also hook on teostra
sdk.hook(sdk.find_type_definition("snow.enemy.em027.Em027CharacterBase"):get_method("doStart"), 
	on_pre_doStart,
	on_post_doStart)

-- also hook on risen teostra
sdk.hook(sdk.find_type_definition("snow.enemy.em027.Em027_08Character"):get_method("doStart"), 
	on_pre_doStart,
	on_post_doStart)


-- draw UI on ScriptGeneratedUI
local TeostraUniqueModeSelection = 1
local TeostraUniqueMode = {"Flame", "Blast"}

re.on_draw_ui(function()
	local changed = false
    changed, value = imgui.combo('Teostra Init Mode', TeostraUniqueModeSelection, TeostraUniqueMode)
    if changed then
        TeostraUniqueModeSelection = value
        if value == 2 then
            TeostraUniqueModeID = 1
        else
            TeostraUniqueModeID = 0
        end
    end
end)
