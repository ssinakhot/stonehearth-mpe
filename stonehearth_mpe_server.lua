
stonehearth_mpe = {
}

local service_creation_order = {
    { player = 'stonehearth_mpe.services.server.player.player_service' },
}

local monkey_patches = {

}

local monkey_patches_headless = {
    mpe_building_service = 'stonehearth.services.server.building.building_service',
    mpe_sim = _radiant.sim,
}

local function monkey_patching(headless)
    local patches = monkey_patches
    if headless then
        patches = monkey_patches_headless
    end
    for from, into in pairs(patches) do
        
        local monkey_see = require('monkey_patches.' .. from)
        local monkey_do = type(into) == "string" and radiant.mods.require(into) or into
        radiant.mixin(monkey_do, monkey_see)
    end
end

local function setup_headless_multiplayer()
   stonehearth.session_server:set_remote_connections_enabled(true)
   stonehearth.session_server:set_max_players(8)
   stonehearth.game_speed:set_anarchy_enabled(true)
end

local function setup_multiplayer()
    local game_options = {}
    if stonehearth_mpe.headless_enabled then
        game_options.remote_connections_enabled = true
        game_options.max_players = 8
        game_options.game_speed_anarchy_enabled = true
    else 
        -- the default host player id should be player_1
        local host_player_id = 'player_1'
        if host_player_id ~= '' then
            local pop = stonehearth.population:get_population(host_player_id)
            game_options = pop:get_game_options()
        else
            radiant.log.write('stonehearth_mpe', 0, 'Multiplayer Setup - No host player id detected. Skipping multiplayer setup.')
            return
        end
    end
    -- Open game to remote players if specified
    if game_options.remote_connections_enabled then
        stonehearth.session_server:set_remote_connections_enabled(true)
        radiant.log.write('stonehearth_mpe', 0, 'Multiplayer Setup - Enabled remote connections')
    end

    -- Set max number of remote players if specified
    if game_options.max_players then
        stonehearth.session_server:set_max_players(game_options.max_players)
        radiant.log.write('stonehearth_mpe', 0, 'Multiplayer Setup - Set max players = ' .. game_options.max_players)
    end

    -- Set whether clients can control game speed
    if game_options.game_speed_anarchy_enabled then
        stonehearth.game_speed:set_anarchy_enabled(game_options.game_speed_anarchy_enabled)
        radiant.log.write('stonehearth_mpe', 0, 'Multiplayer Setup - Enabled client speed control')
    end
end

local save_game_loaded = false

-- this is triggered when the saveid save_game has been loaded
function stonehearth_mpe:_on_game_loaded()
   setup_multiplayer()
   radiant.log.write('stonehearth_mpe', 0, 'Multiplayer - Loaded Save Game')
end

-- this is triggered when saveid is an empty string
-- in stonehearth_server this listener will auto generate the world
function stonehearth_mpe:_on_headless_init() 
    radiant.log.write('stonehearth_mpe', 0, 'Multiplayer - World generation started')
end

-- this is triggered after world generation is completed
function stonehearth_mpe:_on_world_generation_complete()
    setup_multiplayer()
    radiant.log.write('stonehearth_mpe', 0, 'Multiplayer - World Generation Completed')
end

-- this is triggered when a save game isn't loaded 
function stonehearth_mpe:_on_new_game()
    radiant.log.write('stonehearth_mpe', 0, 'Multiplayer - New Game')
end


function stonehearth_mpe:_on_client_join(session)
   stonehearth_mpe.player:add_player(session)
end

function stonehearth_mpe:_on_init() 
    -- print(radiant.util.get_global_config('multiplayer', {}))
    stonehearth_mpe._sv = stonehearth_mpe.__saved_variables:get_data()
    stonehearth_mpe.headless_enabled = radiant.util.get_global_config('multiplayer.server.headless.enabled', false)
    if stonehearth_mpe.headless_enabled then
        radiant.log.write('stonehearth_mpe', 0, 'Headless mode enabled')
    end

    radiant.service_creator.create_services(stonehearth_mpe, 'stonehearth_mpe', service_creation_order)

    radiant.log.write('stonehearth_mpe', 0, 'Server initialized')
end

function stonehearth_mpe:_on_required_loaded()
    monkey_patching()
    if stonehearth_mpe.headless_enabled then
        monkey_patches(true)
    end
end

radiant.events.listen(stonehearth, 'radiant:new_game', stonehearth_mpe, stonehearth_mpe._on_new_game)
radiant.events.listen(stonehearth_mpe, 'radiant:init', stonehearth_mpe, stonehearth_mpe._on_init)
radiant.events.listen(stonehearth.game_creation, 'stonehearth:world_generation_complete', stonehearth_mpe, stonehearth_mpe._on_world_generation_complete)
radiant.events.listen(radiant, 'radiant:game_loaded', stonehearth_mpe, stonehearth_mpe._on_game_loaded)
radiant.events.listen(radiant, 'radiant:client_joined', stonehearth_mpe, stonehearth_mpe._on_client_join)
radiant.events.listen(radiant, 'radiant:headless:init', stonehearth_mpe, stonehearth_mpe._on_headless_init)
radiant.events.listen(radiant, 'radiant:required_loaded', stonehearth_mpe, stonehearth_mpe._on_required_loaded)

local event_test = {
    'radiant:shut_down',
    'radiant:get_host_data',
    'radiant:exit',
    'radiant:client:load_game',
    'radiant:client:restart',
    'radiant:client:return_to_main_menu',
    'radiant:client_removed',
    'radiant:server:restart',
    'radiant:save',
    'radiant:server:save_game',
    'radiant:client:save_game',
    'stonehearth:world_generation_complete'
}

local function output_event_test(event_name)
    radiant.log.write('TEST_EVENT', 0, event_name)
end

local function starts_with(str, start)
   return str:sub(1, #start) == start
end

for index, value in ipairs(event_test) do
    local entity = radiant
    if starts_with(value, 'stonehearth') then
        entity = stonehearth
    end
    radiant.events.listen(entity, value, function()
        output_event_test(value)
    end)
end

return stonehearth_mpe
