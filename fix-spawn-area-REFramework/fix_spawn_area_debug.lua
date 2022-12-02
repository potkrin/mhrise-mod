-- type is the "typeof" variant, not the type definition
local function dump_fields_by_type(type)
    log.debug("Dumping fields...")
    local binding_flags = 32 | 16 | 4 | 8
    local fields = type:call("GetFields(System.Reflection.BindingFlags)", binding_flags)
    if fields then
        fields = fields:get_elements()
        for i, field in ipairs(fields) do
            log.debug("Field: " .. field:call("ToString"))
        end
    end
end
local function dump_fields(object)
    local object_type = object:call("GetType")
    log.debug("dump_fields()")
    dump_fields_by_type(object_type)
end


function on_pre_findBossInitSetInfo(args)
    local args2 = args[2]
    local args3 = args[3]
    local args4 = args[4]
    log.debug("snow.enemy.EnemyManager.findBossInitSetInfo() ")
    log.debug("on_pre_findBossInitSetInfo: args 2: " .. tostring(args2))
    log.debug("on_pre_findBossInitSetInfo: args 3: " .. tostring(args3))
    log.debug("on_pre_findBossInitSetInfo: args 4: " .. tostring(args4))

    -- g_fgbase = sdk.to_managed_object(args[3])
    return sdk.PreHookResult.CALL_ORIGINAL
end

function on_post_findBossInitSetInfo(retval)
    -- local groupid = g_fgbase:get_field("_GroupId")
    -- local fg005id = g_fgbase:get_field("_Fg005Id")
    -- local fgtype = g_fgbase:get_field("_Type")

    -- if fgtype == 4 then 
    --     if groupid == 0 then
    --         if fg005id == LavaAreaID then
    --             g_fgbase:set_field("_ReservedState", 1)
    --         else
    --             g_fgbase:set_field("_ReservedState", 4)
    --         end
    --     end

    --     if groupid == 1 then
    --         if fg005id == WaterAreaID then
    --             g_fgbase:set_field("_ReservedState", 1)
    --         else
    --             g_fgbase:set_field("_ReservedState", 4)
    --         end
    --     end

    -- end
end

	
sdk.hook(sdk.find_type_definition("snow.enemy.EnemyManager"):get_method("findBossInitSetInfo"), 
	on_pre_findBossInitSetInfo,
	on_post_findBossInitSetInfo)

function on_pre_findSetInfo(args)
    local args2 = args[2]
    local args3 = args[3]
    local args4 = args[4]
    local margs2 = sdk.to_managed_object(args[2])
    local margs3 = sdk.to_managed_object(args[3])
    local margs4 = sdk.to_managed_object(args[4])
 
    log.debug("snow.enemy.EnemyManager.findSetInfo() ")
    log.debug("on_pre_findSetInfo: args 2: " .. tostring(args2))
    log.debug("on_pre_findSetInfo: args 3: " .. tostring(args3))
    log.debug("on_pre_findSetInfo: margs 2: " .. tostring(margs2))
    log.debug("on_pre_findSetInfo: margs 3: " .. tostring(margs3))

    -- log.debug("on_pre_findSetInfo: args 2: " .. args2)
    -- log.debug("on_pre_findSetInfo: args 3: " .. args3)
    -- log.debug("on_pre_findSetInfo: margs 2: " .. margs2)
    --log.debug("on_pre_findSetInfo: margs 3: " .. margs3)


    -- dump_fields(margs2)
    -- dump_fields(margs3)



    return sdk.PreHookResult.CALL_ORIGINAL
end

local SpawnAreaID = 0

function on_post_findSetInfo(retval)
    log.debug("on_post_findSetInfo: retval: " .. tostring(retval))
    local mretval = sdk.to_managed_object(retval)
    log.debug("on_post_findSetInfo: mretval: " .. tostring(mretval))

    local setname = mretval:get_field("_SetName")
    log.debug("on_post_findSetInfo: setname: " .. tostring(setname))

    local Info = mretval:get_field("Info")
    log.debug("on_post_findSetInfo: Info: " .. tostring(Info))

    local msetname = sdk.to_managed_object(setname)
    log.debug("on_post_findSetInfo: msetname: " .. tostring(msetname))

    for i = 0, 2 do
        log.debug("before: i = " .. tostring(i) .. " on_post_findSetInfo: Info: " .. tostring(Info[i]))
        log.debug("on_post_findSetInfo: Lot: " .. tostring(Info[i]:get_field("Lot")))
        log.debug("on_post_findSetInfo: Block: " .. tostring(Info[i]:get_field("Block")))
        log.debug("on_post_findSetInfo: _ID: " .. tostring(Info[i]:get_field("_ID")))
    end

    if setname == "メイン" then
        log.debug("on_post_findSetInfo: equal to メイン")
        for i = 0, 2 do
            Info[i]:set_field("Lot", 0)
        end
        Info[SpawnAreaID]:set_field("Lot", 100)
    else
        log.debug("on_post_findSetInfo: NOT equal to メイン")
    end



    for i = 0, 2 do
        log.debug("after: i = " .. tostring(i) .. " on_post_findSetInfo: Info: " .. tostring(Info[i]))
        log.debug("on_post_findSetInfo: Lot: " .. tostring(Info[i]:get_field("Lot")))
        log.debug("on_post_findSetInfo: Block: " .. tostring(Info[i]:get_field("Block")))
        log.debug("on_post_findSetInfo: _ID: " .. tostring(Info[i]:get_field("_ID")))
    end


    -- local setname = retval.get_field("_SetName")
    -- log.debug("on_post_findSetInfo: setname: " .. setname)
    -- local info = retval.get_field("Info")
    -- log.debug("on_post_findSetInfo: info: " .. info)

    log.debug("retval = "..tostring(retval))
    log.debug("mretval = "..tostring(mretval))

    local ptr = sdk.to_ptr(mretval)
    if ptr ~= nil then
        log.debug("ptr is NOT null return ptr")
        return ptr
    else
        log.debug("ptr is null")
    end
 



end


sdk.hook(sdk.find_type_definition("snow.enemy.EnemyBossInitSetData.StageInfo"):get_method("findSetInfo"), 
	on_pre_findSetInfo,
	on_post_findSetInfo)


local SpawnAreaValues = {"A(60%)", "B(30%)", "C(10%)"}
local SpawnAreaSelection = 1

re.on_draw_ui(function()
	local changed = false
	-- if imgui.tree_node("Fix Spawn Area") then   
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
	-- end 
end)



-- local LavaAreaValues = {"12", "13", "14"}
-- local LavaSelection = 1
-- local WaterAreaValues = {"6", "7", "8"}
-- local WaterSelection = 1
 
-- -- draw a Script Generated UI
-- re.on_draw_ui(function()
-- 	imgui.text("FixLava&WaterGimmick")
-- 	imgui.same_line()
-- 	if imgui.button("Options") then
-- 		drawFixLavaWaterGimmickOptionsWindow = true
-- 	end
	
--     -- pop up window for selecting Gimmick Area
--     if drawFixLavaWaterGimmickOptionsWindow then
--         if imgui.begin_window("Fix Lava & Water Gimmick Options", true, 64) then
--             changed, value = imgui.combo('LavaArea', LavaSelection, LavaAreaValues)
-- 			if changed then
--                 LavaSelection = value
--                 if value == 1 then
--                     LavaAreaID = 0
--                 elseif value == 2 then
--                     LavaAreaID = 2
--                 else
--                     LavaAreaID = 1
--                 end
-- 			end

--             changed, value = imgui.combo('WaterArea', WaterSelection, WaterAreaValues)
-- 			if changed then
--                 WaterSelection = value
--                 WaterAreaID = tonumber(value)-1
-- 			end

--             imgui.end_window()
--         else
--             drawFixLavaWaterGimmickOptionsWindow = false
--         end
--     end
-- end)

