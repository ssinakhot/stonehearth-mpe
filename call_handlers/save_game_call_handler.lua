
local SaveGameCallHandler = class()

function SaveGameCallHandler:save_game(session, response)
    _radiant.call("radiant:client:save_game", saveid, {
               name: 'Test',
               town_name: 'Headless Server',
               game_date: gameDate,
               timestamp: d.getTime(),
               time: d.toLocaleString(),
               jobs: {
                  crafters: App.jobController.getNumCrafters(),
                  workers: App.jobController.getNumWorkers(),
                  soldiers: App.jobController.getNumSoldiers(),
               }
            });  
    return true
end

return SaveGameCallHandler

