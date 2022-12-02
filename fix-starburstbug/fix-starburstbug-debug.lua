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


function on_pre_addEnvironmentCreatureLocal(args)
    log.debug('pre_addEnvironmentCreatureLocal')
    local ecb = sdk.to_managed_object(args[3])
    if ecb == nil then
        log.debug('ecb is not REMO')
        return sdk.PreHookResult.CALL_ORIGINAL
    end
    local uid = ecb:get_field('_UniqueID')
    local ectype = ecb:get_field('_Type')
    log.debug('uid = '..tostring(uid))
    log.debug('type = '..tostring(ectype))


    return sdk.PreHookResult.CALL_ORIGINAL
end

function on_post_addEnvironmentCreatureLocal(retval)
    log.debug('post_addEnvironmentCreatureLocal')
    return retval
end

-- this fuction is called on quest start
sdk.hook(sdk.find_type_definition("snow.envCreature.EnvironmentCreatureManager"):get_method("addEnvironmentCreatureLocal"), 
	on_pre_addEnvironmentCreatureLocal,
	on_post_addEnvironmentCreatureLocal)

function on_pre_addUniqueEnvironmentCreature(args)
    log.debug('pre_addUniqueEnvironmentCreature')
    local ecb = sdk.to_managed_object(args[3])
    if ecb == nil then
        log.debug('ecb is not REMO')
        return sdk.PreHookResult.CALL_ORIGINAL
    end
    local uid = ecb:get_field('_UniqueID')
    local ectype = ecb:get_field('_Type')
    if ectype == 60 and (uid == StarBurstID or uid == StarBurstID2) then
        log.debug('uid = '..tostring(uid))
        log.debug('type = '..tostring(ectype))
        fromScript = true
        ecb:call("forceRequestElement", ElementID, 0)
        fromScript = false
    end


    return sdk.PreHookResult.CALL_ORIGINAL
end

function on_post_addUniqueEnvironmentCreature(retval)
    log.debug('post_addUniqueEnvironmentCreature')
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

-- following functions are not used in MHRiseSunbreak:DEMO



-- function on_pre_addEnvironmentCreature(args)
--     log.debug('pre_addEnvironmentCreature')
--     local ecb = sdk.to_managed_object(args[3])
--     if ecb == nil then
--         log.debug('ecb is not REMO')
--         return sdk.PreHookResult.CALL_ORIGINAL
--     end
--     local uid = ecb:get_field('_UniqueID')
--     local ectype = ecb:get_field('_Type')
--     log.debug('uid = '..tostring(uid))
--     log.debug('type = '..tostring(ectype))


--     return sdk.PreHookResult.CALL_ORIGINAL
-- end

-- function on_post_addEnvironmentCreature(retval)
--     log.debug('post_addEnvironmentCreature')
--     return retval
-- end

-- -- this fuction is called on quest start
-- sdk.hook(sdk.find_type_definition("snow.envCreature.EnvironmentCreatureManager"):get_method("addEnvironmentCreature"), 
-- 	on_pre_addEnvironmentCreature,
-- 	on_post_addEnvironmentCreature)


-- function on_pre_addEnvironmentCreatureSync(args)
--     log.debug('pre_addEnvironmentCreatureSync')
--     local ecb = sdk.to_managed_object(args[3])
--     if ecb == nil then
--         log.debug('ecb is not REMO')
--         return sdk.PreHookResult.CALL_ORIGINAL
--     end
--     local uid = ecb:get_field('_UniqueID')
--     local ectype = ecb:get_field('_Type')
--     log.debug('uid = '..tostring(uid))
--     log.debug('type = '..tostring(ectype))


--     return sdk.PreHookResult.CALL_ORIGINAL
-- end

-- function on_post_addEnvironmentCreatureSync(retval)
--     log.debug('post_addEnvironmentCreatureSync')
--     return retval
-- end

-- -- this fuction is called on quest start
-- sdk.hook(sdk.find_type_definition("snow.envCreature.EnvironmentCreatureManager"):get_method("addEnvironmentCreatureSync"), 
-- 	on_pre_addEnvironmentCreatureSync,
-- 	on_post_addEnvironmentCreatureSync)