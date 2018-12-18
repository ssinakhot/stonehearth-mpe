local PlayerCallHandler = class()

function PlayerCallHandler:is_player_host(session, response)
    -- player service only exists if headless server mode is true
    if stonehearth_mpe.player then
        return stonehearth_mpe.player:get_host_player_id() == session.player_id
    else 
        return _radiant.sim.get_host_player_id() == session.player_id
    end
end

return PlayerCallHandler