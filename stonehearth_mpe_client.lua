
stonehearth_mpe = {
}

local service_creation_order = {
}

local monkey_patches = {
    mpe_building_client_service = 'stonehearth.services.client.building.building_client_service',
    mpe_client = _radiant.client,
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
   print(path)
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

function stonehearth_mpe:_on_init() 
   stonehearth_mpe._sv = stonehearth_mpe.__saved_variables:get_data()

   for _, name in ipairs(service_creation_order) do
      create_service(name)
   end

   radiant.log.write('stonehearth_mpe', 0, 'Client initialized')
end

function stonehearth_mpe:_on_required_loaded()
    monkey_patching()
end

radiant.events.listen(stonehearth_mpe, 'radiant:init', stonehearth_mpe, stonehearth_mpe._on_init)
radiant.events.listen(radiant, 'radiant:required_loaded', stonehearth_mpe, stonehearth_mpe._on_required_loaded)

return stonehearth_mpe
