-- REFramework Modding TIPS
--   snow.~ can be found in REFrameworkWindow -> DeveloperTools -> ObjectExplorer -> Singletons or Types
--   DeveloperTools -> GameObjectsDisplay is also helpful to find the inGameName of the objects you want

log.info("[FixLavaWaterGimmick] started loading")
-- 0: area 12, 1: area 14, 2: area 13
local LavaAreaID = 0
-- 0: area 6, 1: area 7, 2: area 8
local WaterAreaID = 0

-- FieldGimmickBase variable 
local g_fgbase = nil;

-- excuted before addFieldGimmick()
-- save FieldGimmickBase variable as a global variable (g_fgbase) and pass it to on_post_addFieldGimmick()
-- args[2] is an snow.stage.FieldGimmickManager
-- args[3] is an snow.stage.FieldGimmickBase
function on_pre_addFieldGimmick(args)
    g_fgbase = sdk.to_managed_object(args[3])
    return sdk.PreHookResult.CALL_ORIGINAL
end

-- executed after addFieldGimmick()
-- set all field:_ReservedState in the Group to 4. Then, choose the Fg005Id which you want to activate and set the filed:_ReservedState to 1
-- 
-- Note
--   Lava and Water gimmick is called [snow.stage.Fg005] in game
--   Fg005 is based on snow.stage.FieldGimmickBase
--   _GroupId 0: LavaGimmick, 1: WaterGimmick
--   _GroupId 0 & _Fg005 0 : Area 12
--            & _Fg005 1 : Area 14
--            & _Fg005 2 : Area 13
--   _GroupId 1 & _Fg005 0 : Area 6
--            & _Fg005 1 : Area 7
--            & _Fg005 2 : Area 8
--   _Type field of Fg005 is 4
--   snow.stage.FieldGimmick.Fg005State _ReservedState -1: Invalid, 0: Disabled, 1: Standby, 2: PreActivate, 3: Activate, 4: Finished

function on_post_addFieldGimmick(retval)
    local groupid = g_fgbase:get_field("_GroupId")
    local fg005id = g_fgbase:get_field("_Fg005Id")
    local fgtype = g_fgbase:get_field("_Type")

    if fgtype == 4 then 
        if groupid == 0 then
            if fg005id == LavaAreaID then
                g_fgbase:set_field("_ReservedState", 1)
            else
                g_fgbase:set_field("_ReservedState", 4)
            end
        end

        if groupid == 1 then
            if fg005id == WaterAreaID then
                g_fgbase:set_field("_ReservedState", 1)
            else
                g_fgbase:set_field("_ReservedState", 4)
            end
        end

    end
end

	
sdk.hook(sdk.find_type_definition("snow.stage.FieldGimmickManager"):get_method("addFieldGimmick"), 
	on_pre_addFieldGimmick,
	on_post_addFieldGimmick)

local LavaAreaValues = {"12", "13", "14"}
local LavaSelection = 1
local WaterAreaValues = {"6", "7", "8"}
local WaterSelection = 1
 
-- draw a Script Generated UI
re.on_draw_ui(function()
	imgui.text("FixLava&WaterGimmick")
	imgui.same_line()
	if imgui.button("Options") then
		drawFixLavaWaterGimmickOptionsWindow = true
	end
	
    -- pop up window for selecting Gimmick Area
    if drawFixLavaWaterGimmickOptionsWindow then
        if imgui.begin_window("Fix Lava & Water Gimmick Options", true, 64) then
            changed, value = imgui.combo('LavaArea', LavaSelection, LavaAreaValues)
			if changed then
                LavaSelection = value
                if value == 1 then
                    LavaAreaID = 0
                elseif value == 2 then
                    LavaAreaID = 2
                else
                    LavaAreaID = 1
                end
			end

            changed, value = imgui.combo('WaterArea', WaterSelection, WaterAreaValues)
			if changed then
                WaterSelection = value
                WaterAreaID = tonumber(value)-1
			end

            imgui.end_window()
        else
            drawFixLavaWaterGimmickOptionsWindow = false
        end
    end
end)

log.info("[FixLavaWaterGimmick] finished loading")
