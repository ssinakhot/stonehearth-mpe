local PlayerService = class()

function PlayerService:initialize()
    self._sv = self.__saved_variables:get_data()
    if not self._sv.players then 
        self._sv.players = {}
    end

    if not self._sv.host_player_id then
        self._sv.host_player_id = ''
    end
    radiant.events.listen(stonehearth.population, 'stonehearth:population:camp_placed', function() 
        stonehearth_mpe.player:remove_host()
    end)
end

function PlayerService:destroy_player(player_id)
   _radiant.sim.remove_player(player_id)
   _radiant.sim.destroy_player_entities(player_id)
   stonehearth.player:remove_player(player_id)
end

function PlayerService:transfer_player(src_player_id, dest_player_id) 
   _radiant.sim.remove_player(src_player_id)
   stonehearth.player:transfer_player_entities(src_player_id, dest_player_id)
   stonehearth.player:remove_player(player_id)
end

function PlayerService:get_host_player_id()
    return self._sv.host_player_id
end

function PlayerService:add_player(session)
    if self._sv.players[session.player_id] == nil then
        radiant.log.write('stonehearth_mpe', 0, 'Player \'%s\' has joined', session.player_id)
        self._sv.players[session.player_id] = session
    end
    if self._sv.host_player_id == '' and session.provider == 'develop' then
        stonehearth_mpe.player:override_host_player_id(session)
    end
end

function PlayerService:override_host_player_id(session)
    self._sv.host_player_id = session.player_id
    radiant.log.write('stonehearth_mpe', 0, 'Host assigned to player \'%s\'', session.player_id)
end

function PlayerService:remove_host()
    if stonehearth.player:get_players()['player_1'] then
        self._sv.players['player_1'] = nil
        stonehearth_mpe.player:destroy_player('player_1')
        radiant.log.write('stonehearth_mpe', 0, 'Remove original host \'player_1\'')
    end  
end

return PlayerService