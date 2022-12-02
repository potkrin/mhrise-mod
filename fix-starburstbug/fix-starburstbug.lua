local ElementID = 1
local StarBurstID = 5000
local StarBurstID2 = 11

local fromScript = false

function on_pre_forceRequestElement(args)
    if fromScript then
        return sdk.PreHookResult.CALL_ORIGINAL
    else
        return sdk.PreHookResult.SKIP_ORIGINAL
    end
end

function on_post_forceRequestElement(retval)
    return retval
end

-- this fuction is called on quest start
sdk.hook(sdk.find_type_definition("snow.envCreature.Ec055"):get_method("forceRequestElement"), 
	on_pre_forceRequestElement,
	on_post_forceRequestElement)


function on_pre_addUniqueEnvironmentCreature(args)
    local ecb = sdk.to_managed_object(args[3])
    if ecb == nil then
        return sdk.PreHookResult.CALL_ORIGINAL
    end
    local uid = ecb:get_field('_UniqueID')
    local ectype = ecb:get_field('_Type')
    if ectype == 60 and (uid == StarBurstID or uid == StarBurstID2) then
        fromScript = true
        ecb:call("forceRequestElement", ElementID, 0)
        fromScript = false
    end
    return sdk.PreHookResult.CALL_ORIGINAL
end

function on_post_addUniqueEnvironmentCreature(retval)
    return retval
end

-- this fuction is called on quest start
sdk.hook(sdk.find_type_definition("snow.envCreature.EnvironmentCreatureManager"):get_method("addUniqueEnvironmentCreature"), 
	on_pre_addUniqueEnvironmentCreature,
	on_post_addUniqueEnvironmentCreature)


local StarBurstElement = {"Fire", "Thunder", "Water", "Ice"}
local ElementSelection = 1

local StarBurstPos = {"1", "2", "3", "4"}
local PosSelection = 1

re.on_draw_ui(function()
	local changed = false
    changed, value = imgui.combo('Set Element(StarBurst)', ElementSelection, StarBurstElement)
    if changed then
        ElementSelection = value
        ElementID = value
    end
	local changedPos = false
    changedPos, valuePos = imgui.combo('Set Pos(StarBurst)', PosSelection, StarBurstPos)
    if changedPos then
        PosSelection = valuePos
        if valuePos == 1 then
            StarBurstID = 5000
            StarBurstID2 = 11
        elseif valuePos == 2 then
            StarBurstID = 5001
            StarBurstID2 = 12
        elseif valuePos == 3 then
            StarBurstID = 5002
            StarBurstID2 = 13
        elseif valuePos == 4 then
            StarBurstID = 5003
            StarBurstID2 = 14
        else
            StarBurstID = 5000
            StarBurstID2 = 11
        end
    end
end)
