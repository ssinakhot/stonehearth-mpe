local PlayerService = class()

function PlayerService:initialize()
    self._sv = self.__saved_variables:get_data()
    if not self._sv.players then 
        self._sv.players = {}
    end

    if not self._sv.host_player_id then
        self._sv.host_player_id = ''
    end
end

function PlayerService:destroy_player_entities(player_id)
   _radiant.sim.remove_player(player_id)
   _radiant.sim.destroy_player_entities(player_id)
   stonehearth.player:remove_player(player_id)
end

function PlayerService:transfer_player_entities(src_player_id, dest_player_id) 
   _radiant.sim.remove_player(src_player_id)
   stonehearth.player:transfer_player_entities(src_player_id, dest_player_id)
   stonehearth.player:remove_player(player_id)
end

function PlayerService:get_host_player_id()
    return self._sv.host_player_id
end

function PlayerService:add_player(session)
    if self._sv.host_player_id == '' then
        self._sv.host_player_id = session.player_id
        radiant.log.write('stonehearth_mpe', 0, 'Host assigned to \'%s\'', session.player_id)
    end
    table.insert(self._sv.players, session)
end

return PlayerService