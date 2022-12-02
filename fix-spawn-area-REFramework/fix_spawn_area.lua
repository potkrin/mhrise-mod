-- fix_spawn_area.lua : written by hotkrin
-- fix the main monster's spawn area by reframework. (no need to restart game)

function on_pre_findSetInfo(args)
    return sdk.PreHookResult.CALL_ORIGINAL
end

local SpawnAreaID = 0

function on_post_findSetInfo(retval)
    local mretval = sdk.to_managed_object(retval)
    local setname = mretval:get_field("_SetName")
    local Info = mretval:get_field("Info")

    if setname == "メイン" then
        for i = 0, 2 do
            Info[i]:set_field("Lot", 0)
        end
        Info[SpawnAreaID]:set_field("Lot", 100)
    end

    local ptr = sdk.to_ptr(mretval)
    if ptr ~= nil then
        return ptr
    end
end


sdk.hook(sdk.find_type_definition("snow.enemy.EnemyBossInitSetData.StageInfo"):get_method("findSetInfo"), 
	on_pre_findSetInfo,
	on_post_findSetInfo)


local SpawnAreaValues = {"A(60%)", "B(30%)", "C(10%)"}
local SpawnAreaSelection = 1

re.on_draw_ui(function()
	local changed = false
    changed, value = imgui.combo('Spawn Area', SpawnAreaSelection, SpawnAreaValues)
    if changed then
        SpawnAreaSelection = value
        if value == 1 then
            SpawnAreaID = 0
        elseif value == 2 then
            SpawnAreaID = 1
        else
            SpawnAreaID = 2
        end
    end
end)
