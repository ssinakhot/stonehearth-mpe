local MpeSim = {}

--[[
Override the native client code to get host player id
Host is now retrieved from stonehearth_mpe.services.server.player.player_service
--]]
MpeSim._old_get_host_player_id = _radiant.sim.get_host_player_id
function MpeSim.get_host_player_id()
    return stonehearth_mpe.player:get_host_player_id()
end

return MpeSim 
