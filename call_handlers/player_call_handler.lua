local PlayerCallHandler = class()

function PlayerCallHandler:is_player_host(session, response)
    return stonehearth_mpe.player:get_host_player_id() == session.player_id
end

return PlayerCallHandler