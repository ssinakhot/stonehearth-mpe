
stonehearth_mpe = {
}

local service_creation_order = {
}

local monkey_patches = {

}

local headless_monkey_patches = {
   mpe_building_client_service = 'stonehearth.services.client.building.building_client_service',
   mpe_client = _radiant.client,
}

local function monkey_patching(headless)
   local patches = monkey_patches
   if headless then
      patches = headless_monkey_patches
   end
   for from, into in pairs(patches) do
      local monkey_see = require('monkey_patches.' .. from)
      local monkey_do = type(into) == "string" and radiant.mods.require(into) or into
      radiant.mixin(monkey_do, monkey_see)
   end
end

function stonehearth_mpe:_on_init() 
   stonehearth_mpe._sv = stonehearth_mpe.__saved_variables:get_data()
   radiant.service_creator.create_services(stonehearth_mpe, 'stonehearth_mpe', service_creation_order)
  
   radiant.log.write('stonehearth_mpe', 0, 'Client initialized')
end

function stonehearth_mpe:_on_required_loaded()
   monkey_patching()
end

function stonehearth_mpe:_on_server_ready()
   _radiant.call('stonehearth_mpe:is_headless_mode_enabled'):done(function(r)
      stonehearth_mpe.headless_enabled = r.result;
      if stonehearth_mpe.headless_enabled then
         monkey_patching(true)
      end
   end)
end

-- joining a remote game
function stonehearth_mpe:_on_game_joined()
   print('remote game joined')
end

radiant.events.listen(stonehearth_mpe, 'radiant:init', stonehearth_mpe, stonehearth_mpe._on_init)
radiant.events.listen(radiant, 'radiant:required_loaded', stonehearth_mpe, stonehearth_mpe._on_required_loaded)
radiant.events.listen(radiant, 'radiant:client:game_joined', stonehearth_mpe, stonehearth_mpe._on_game_joined)
radiant.events.listen(radiant, 'radiant:client:server_ready', stonehearth_mpe, stonehearth_mpe._on_server_ready)

return stonehearth_mpe
