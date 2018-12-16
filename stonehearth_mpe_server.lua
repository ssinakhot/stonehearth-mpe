
stonehearth_mpe = {
}

local service_creation_order = {
    'player'
}

local monkey_patches = {
    mpe_building_service = 'stonehearth.services.server.building.building_service',
    mpe_sim = _radiant.sim,
}

local function monkey_patching()
   for from, into in pairs(monkey_patches) do
      
      local monkey_see = require('monkey_patches.' .. from)
      local monkey_do = type(into) == "string" and radiant.mods.require(into) or into
      radiant.mixin(monkey_do, monkey_see)
   end
end

local function create_service(name)
   local path = string.format('services.server.%s.%s_service', name, name)
   local service = require(path)()

   local saved_variables = stonehearth_mpe._sv[name]
   if not saved_variables then
      saved_variables = radiant.create_datastore()
      stonehearth_mpe._sv[name] = saved_variables
   end

   service.__saved_variables = saved_variables
   service._sv = saved_variables:get_data()
   saved_variables:set_controller(service)
   saved_variables:set_controller_name('stonehearth_mpe:' .. name)
   service:initialize()
   stonehearth_mpe[name] = service
end

function stonehearth_mpe:_on_headless_init() 
   stonehearth.session_server:set_remote_connections_enabled(true)
   stonehearth.session_server:set_max_players(8)
   stonehearth.game_speed:set_anarchy_enabled(true)
   radiant.log.write('stonehearth_mpe', 0, 'Multiplayer initialized')
end

function stonehearth_mpe:_on_client_join(session)
    stonehearth_mpe.player:add_player(session)
end

function stonehearth_mpe:_on_init() 
   print(radiant.util.get_global_config('multiplayer', {}))
   stonehearth_mpe._sv = stonehearth_mpe.__saved_variables:get_data()

   for _, name in ipairs(service_creation_order) do
      create_service(name)
   end

   radiant.log.write('stonehearth_mpe', 0, 'Server initialized')
end

function stonehearth_mpe:_on_new_game()
    print('new_game')
    local options = radiant.util.get_global_config('multiplayer.server.headless.options', {})
    stonehearth.game_creation:build_world(options)
end

function stonehearth_mpe:_on_required_loaded()
    monkey_patching()
end

--radiant.events.listen(stonehearth, 'radiant:new_game', stonehearth_mpe, stonehearth_mpe._on_new_game)
radiant.events.listen(stonehearth_mpe, 'radiant:init', stonehearth_mpe, stonehearth_mpe._on_init)
radiant.events.listen(radiant, 'radiant:client_joined', stonehearth_mpe, stonehearth_mpe._on_client_join)
radiant.events.listen(radiant, 'radiant:headless:init', stonehearth_mpe, stonehearth_mpe._on_headless_init)
radiant.events.listen(radiant, 'radiant:required_loaded', stonehearth_mpe, stonehearth_mpe._on_required_loaded)

local event_test = {
    --'radiant:new_game',
    'radiant:save',
    'radiant:server:save_game',
    'radiant:client:save_game',
    'radiant:game_loaded',
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
