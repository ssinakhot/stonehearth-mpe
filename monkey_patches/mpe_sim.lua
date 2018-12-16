local MpeSim = {}

MpeSim._old_get_host_player_id = _radiant.sim.get_host_player_id
function MpeSim.get_host_player_id()
    return stonehearth_mpe.player:get_host_player_id()
end

return MpeSim 
