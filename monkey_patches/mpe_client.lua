local MpeClient = {}

--[[
Override the native client code to check for host.
Host is now retrieved from stonehearth_mpe.services.server.player.player_service
--]]
MpeClient._old_is_authenticated_as_host = _radiant.client.is_authenticated_as_host
function MpeClient.is_authenticated_as_host()
    return _radiant.call('stonehearth_mpe:is_player_host')
end

return MpeClient

