local g_frogCount;
local FrogTypeID = 3;
local FrogSpawnID = {1, 2, 3}

function on_pre_addUniqueEnvironmentCreature(args)
    -- if map is not Citadel, do nothing.
    local MapManager = sdk.get_managed_singleton("snow.QuestMapManager")   
    local MapNoType = MapManager:call("get_CurrentMapNo")
    if MapNoType ~= 13 then
        return sdk.PreHookResult.CALL_ORIGINAL
    end
 
    local ecb = sdk.to_managed_object(args[3])
    g_ecbase = ecb;
    if ecb == nil then
        return sdk.PreHookResult.CALL_ORIGINAL
    end
    local uid = ecb:get_field('_UniqueID')
    local ectype = ecb:get_field('_Type')

    if (uid == 1000 or uid == 1001 or uid == 1002) and (ectype == 1 or ectype == 2 or ectype == 3 or ectype == 4) then

        local frogSpawnPosition = {
            Vector3f.new(73.188812255859, 6.2469792366028, 141.63720703125), 
            Vector3f.new(-11.216859817505, 36.66482925415, 76.75993347168),
            Vector3f.new(119.32559967041, 72.408683776855, -160.533203125)
        }

        if g_frogCount < 3 then
            ecb:call('set_Pos', frogSpawnPosition[FrogSpawnID[g_frogCount+1]])
            g_frogCount = g_frogCount + 1
        end
    end

    return sdk.PreHookResult.CALL_ORIGINAL
end

function on_post_addUniqueEnvironmentCreature(retval)
   return retval
end

sdk.hook(sdk.find_type_definition("snow.envCreature.EnvironmentCreatureManager"):get_method("addUniqueEnvironmentCreature"), 
	on_pre_addUniqueEnvironmentCreature,
	on_post_addUniqueEnvironmentCreature)


function on_pre_initQuestStart(args)
    g_frogCount = 0
    return sdk.PreHookResult.CALL_ORIGINAL
end

function on_post_initQuestStart(retval)
    return retval
end

sdk.hook(sdk.find_type_definition("snow.envCreature.EnvironmentCreatureManager"):get_method("initQuestStart"), 
	on_pre_initQuestStart,
	on_post_initQuestStart)


-- change all frog type in the RandomTableData to 'local FrogTypeID'
-- this table will be used on addUniqueEnvironmentCreature()
-- Default Table Content    
-- Type     : Probability
-- 3(Blast) : 35%
-- 4(Poison): 35%
-- 2(Para)  : 20%
-- 1(Sleep) : 10%
function on_pre_getRandomTableData(args)
    return sdk.PreHookResult.CALL_ORIGINAL
end

function on_post_getRandomTableData(retval)
    -- if map is not Citadel, do nothing.
    local MapManager = sdk.get_managed_singleton("snow.QuestMapManager")   
    local MapNoType = MapManager:call("get_CurrentMapNo")
    if MapNoType ~= 13 then
        return retval
    end
 
    local table = sdk.to_managed_object(retval)
    if table == nil then
        return retval
    end
    ecdata = table:get_field('_ECData')
    datalist = ecdata:get_field('_DataList')

    for k = 0, 3 do
        local item = datalist:call('get_Item(System.Int32)', k)
        local type = item:get_field("_Type")
        if 0 < type and type < 5 then
            item:set_field("_Type", FrogTypeID)
        end
    end
    return retval
end

sdk.hook(sdk.find_type_definition("snow.envCreature.EnvironmentCreatureManager"):get_method("getRandomTableData"), 
	on_pre_getRandomTableData,
	on_post_getRandomTableData)

-- draw UI on ScriptGeneratedUI
local FrogTypeSelection = 1
local FrogType = {"Blast", "Para", "Sleep", "Poison"}

local FrogSpawnSelection = 1
local FrogSpawn = {"Area 1", "Area 2", "Area 4"}

re.on_draw_ui(function()
	local changed = false
    changed, value = imgui.combo('Frog Type(Citadel)', FrogTypeSelection, FrogType)
    if changed then
        FrogTypeSelection = value
        if value == 1 then
            FrogTypeID = 3
        elseif value == 2 then
            FrogTypeID = 1
        elseif value == 3 then
            FrogTypeID = 2
        else
            FrogTypeID = 4
        end
    end
	local changedSpawn = false
    changedSpawn, valueSpawn = imgui.combo('Frog Spawn(Citadel)', FrogSpawnSelection, FrogSpawn)
    if changedSpawn then
        FrogSpawnSelection = valueSpawn
        if valueSpawn == 1 then
            FrogSpawnID = {1, 2, 3}
        elseif valueSpawn == 2 then
            FrogSpawnID = {2, 1, 3}
        elseif valueSpawn == 3 then
            FrogSpawnID = {3, 1, 2}
        end
    end
end)