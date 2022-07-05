--HYPERSCRIPT DEV VERSION 1.0--


util.require_natives(1651208000)


--[PLAYER FEATURES]==
local function generateFeatures(pid)
    
    menu.divider(menu.player_root(pid), "Hyperscript 1.0")

    local playerroot = menu.player_root(pid)
    local attachroot = menu.list(playerroot, "Attach to Vehicle", {}, "")
    local eventroot = menu.list(playerroot, "Script Events", {}, "")
    local trollroot = menu.list(playerroot, "Trolling", {}, "")
    local godroot = menu.list(playerroot, "Kill Godmode Players", {}, "")
    local offset = 1

    --EVENT ROOT--
    menu.action(eventroot, "Send to Beach", {sendbeach}, "Sends them to the beach!", function()
        util.trigger_script_event(1 << pid, {1463943751, 0, 0, 0, 4,  0})
    end)

    menu.action(eventroot, "Force On Bike", {putonbike}, "Forces them onto a bike.", function()
        util.trigger_script_event(1 << pid, {962740265, PLAYER.PLAYER_ID(), 1, 32, NETWORK.NETWORK_HASH_FROM_PLAYER_HANDLE(pid), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1})
    end)

    menu.action(eventroot, "Invite to Property", {}, "Sends them an invite to a property.", function()
        util.trigger_script_event(1 << pid, {1132878564, players.user(), --[[PROPERTY]] math.random(1, 6)})
    end)

    menu.action(eventroot, "Fake Money Dropped Notification", {}, "", function()
        util.trigger_script_event(1 << pid, {677240627, players.user(), 1903175301, 1000000000, math.random(-2147483647, 2147483647), 0, 0, 0, 0, 0, 0, pid, p10, 0, 0, 0})
    end)

    menu.toggle_loop(attachroot, "Attach to their Vehicle", {}, "Attaches yourself to their vehicle.", function(on_tick)
        local theirped = PLAYER.GET_PLAYER_PED(pid)
        theirveh = PED.GET_VEHICLE_PED_IS_IN(theirped, false)
        ENTITY.ATTACH_ENTITY_TO_ENTITY(players.user_ped(), theirveh, 0, 0, 0, offset, 0, 0, 0, false, false, false, true, 0, true)
    end, function(on_stop)
        ENTITY.DETACH_ENTITY(players.user_ped(), false, false)
    end)

    menu.slider(attachroot, "Offset", {}, "Controls how high up your character is.", 0, 10, 1, 1, function(value)
        offset = value
    end)

    menu.action(playerroot, "Send Targeted Messsage", {"tarmsg"}, "", function()
        local name = PLAYER.GET_PLAYER_NAME(pid)
        util.toast("Please input the message")
        menu.show_command_box("tarmsg" .. name .. " ")
    end, function(on_command)
        local name = PLAYER.GET_PLAYER_NAME(pid)
        local message = on_command
        chat.send_targeted_message(pid, PLAYER.PLAYER_ID(), ("[To " .. name .. "] " .. message), true)
    end)

    --[PRISMS GODMODE REMOVER]
    menu.action(godroot, "Kill Godmode Player", {"killgodmode"}, "Note: this will not work if they have no ragdoll on", function()
        local id = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local playerpos = ENTITY.GET_ENTITY_COORDS(id)
        playerpos.z = playerpos.z + 3

        local khanjali = util.joaat("khanjali")
        STREAMING.REQUEST_MODEL(khanjali)
        while not STREAMING.HAS_MODEL_LOADED(khanjali) do
            util.yield()
        end

        local vehicle1 = entities.create_vehicle(khanjali, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(pid), 0, 2, 3), ENTITY.GET_ENTITY_HEADING(id))
        local vehicle2 = entities.create_vehicle(khanjali, playerpos, 0)
        local vehicle3 = entities.create_vehicle(khanjali, playerpos, 0)
        local vehicle4 = entities.create_vehicle(khanjali, playerpos, 0)

        NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle1)
        NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle2)
        NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle3)
        NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle4)

        ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle2, vehicle1, 0, 0, 3, 0, 0, 0, -180, 0, false, true, false, 0, true)
        ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle3, vehicle1, 0, 3, 3, 0, 0, 0, -180, 0, false, true, false, 0, true)
        ENTITY.ATTACH_ENTITY_TO_ENTITY(vehicle4, vehicle1, 0, 3, 0, 0, 0, 0, 0, 0, false, true, false, 0, true)
        ENTITY.SET_ENTITY_VISIBLE(vehicle1, false)
        util.yield(7500)
        entities.delete_by_handle(vehicle1)
    end) 

    menu.toggle_loop(godroot, "Remove Godmode", {"removegm"}, "removes the players godmode by forcing camera forward. blocked by most menus", function()
        if not players.exists(pid) then
            util.stop_thread()
        end
        util.trigger_script_event(1 << pid, {801199324, pid, 869796886, math.random(0, 9999)})
        end)

    --MORE FUNCTIONS TO COME--
end

--LOCAL FEATURES--
menu.divider(menu.my_root(), "Hyperscript 1.0")
local myroot = menu.my_root()
local selfroot = menu.list(myroot, "Self", {}, "")
local vehroot = menu.list(myroot, "Vehicle", {}, "")
local gameroot = menu.list(myroot, "Game", {}, "")
local worldroot = menu.list(myroot, "World", {}, "")

menu.toggle_loop(selfroot, "Comic Gun", {}, "Makes your shooting... cooler", function(on_tick)
    GRAPHICS.USE_PARTICLE_FX_ASSET("scr_rcbarry2")

        while not STREAMING.HAS_NAMED_PTFX_ASSET_LOADED("scr_rcbarry2") do
            STREAMING.REQUEST_NAMED_PTFX_ASSET("scr_rcbarry2")
            util.yield()
        end

        if PED.IS_PED_SHOOTING(players.user_ped()) then
            local pos = PED.GET_PED_BONE_COORDS(players.user_ped(), 26610,0, 0, 0)
            ptfx = GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD("muz_clown", pos.x, pos.y, pos.z, 0, 0, 0, 1, false, false,false)
        end

    end, function(on_stop)
        GRAPHICS.REMOVE_PARTICLE_FX(ptfx, true)
        STREAMING.REMOVE_NAMED_PTFX_ASSET("scr_rcbarry2")
end)


--notable scaleforms
--BREAKING_NEWS

menu.toggle_loop(selfroot, "News Chase", {}, "", function()
    scope_scaleform = GRAPHICS.REQUEST_SCALEFORM_MOVIE('BREAKING_NEWS')
    GRAPHICS.BEGIN_SCALEFORM_MOVIE_METHOD(scope_scaleform, 'BREAKING_NEWS')
    GRAPHICS.DRAW_SCALEFORM_MOVIE_FULLSCREEN(scope_scaleform, 255, 255, 255, 255, 0)
    GRAPHICS.CALL_​SCALEFORM_​MOVIE_​METHOD_​WITH_​STRING(​scope_scaleform, SET_TEXT(), "Your mom is cool!", "")
end, function()
    local pScaleform = memory.alloc_int()
    memory.write_int(pScaleform, scope_scaleform)
    GRAPHICS.SET_SCALEFORM_MOVIE_AS_NO_LONGER_NEEDED(pScaleform)
end)


players.on_join(generateFeatures)
players.dispatch_on_join()

util.keep_running()

