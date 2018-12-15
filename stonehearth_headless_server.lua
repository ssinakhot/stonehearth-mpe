
stonehearth_headless = {

}

function stonehearth_headless:_on_headless_init() 
   stonehearth.session_server:set_remote_connections_enabled(true)
   stonehearth.session_server:set_max_players(8)
   stonehearth.game_speed:set_anarchy_enabled(true)
   radiant.log.write_('stonehearth_headless', 0, 'headless initialized')
end

function stonehearth_headless:_on_init() 
    radiant.log.write_('stonehearth_headless', 0, 'initialized')
end

function stonehearth_headless:_on_required_loaded()
    radiant.log.write_('stonehearth_headless', 0, 'required loaded')
    -- todo monkey patching?
end

radiant.events.listen(stonehearth_headless, 'radiant:init', stonehearth_headless, stonehearth_headless._on_init)
radiant.events.listen(radiant, 'radiant:headless:init', stonehearth_headless, stonehearth_headless._on_headless_init)
radiant.events.listen(radiant, 'radiant:required_loaded', stonehearth_headless, stonehearth_headless._on_required_loaded)

local event_test = {
    'radiant:save',
    'radiant:server:save_game',
    'radiant:client:save_game',
    'radiant:headless:init',
    'radiant:game_loaded'
}

local function output_event_test(event_name)
    radiant.log.write_('TEST_EVENT', 0, event_name)
end

for index, value in ipairs(event_test) do
    radiant.events.listen(radiant, value, function()
        output_event_test(value)
    end)
end

return stonehearth_headless
