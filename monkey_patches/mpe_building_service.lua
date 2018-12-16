local BuildingService = require 'stonehearth.services.server.building.building_service'
local MpeBuildingService = class()

local template_utils = require 'stonehearth.lib.building.template_utils'

--[[
Override function because the "host" isn't really a host.
It's a remote client that is treated like a "host".
--]]
MpeBuildingService._old_save_building_command = BuildingService.save_building_command
function MpeBuildingService:save_building_command(session, response, building_id)
   local building = self._sv.buildings:get(building_id)

   local template = template_utils.get_template_save_data(building)
   local template_id = building:get('stonehearth:build2:building'):get_template_id()

   response:resolve({ template_id = template_id, template = template })
end

return MpeBuildingService