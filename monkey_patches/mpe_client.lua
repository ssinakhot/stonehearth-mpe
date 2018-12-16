local MpeClient = {}

MpeClient._old_is_authenticated_as_host = _radiant.client.is_authenticated_as_host
function MpeClient.is_authenticated_as_host()
    return _radiant.call('stonehearth_mpe:is_player_host')
end

return MpeClient

