local BuildingClientService = require 'stonehearth.services.client.building.building_client_service'
local MpeBuildingClientService = class()

local template_utils = require 'stonehearth.lib.building.template_utils'

--[[
Override function because the "host" isn't really a host.
It's a remote client that is treated like a "host".
--]]
MpeBuildingClientService._old_place_building = BuildingClientService.place_building
function MpeBuildingClientService:place_building(template_id, offset, rot_point, rot)
    local template = template_utils.load_template_data(template_id)
    _radiant.call_obj(self._build_service, 'load_building_from_data_command', template_id, offset, rot_point, rot, template):done(function(res)
        self:_update_current_building(res.result)
        end)
end

return MpeBuildingClientService