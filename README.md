# stonehearth_mpe 
Stonehearth Multiplayer Enhancements

This mod focuses on being able run a headless server and extending multiplayer modes by adding a "game master" host.

Save a game and update the host field in server_metadata.json with your session information. Your player_id is either develop_1 or steam_1

    {
        'player_id': 'develop_1',
        'client_id': 'GUID',
        'provider': 'develop
    }

radiant:client:save_game will trigger a save on the server if the client is connected as a 'host'. You can specify your host in an existing save game by modifying server_metadata.json with the correct user session information.

radiant:client:restart will trigger a restart of the game on the server side! the new_game event will kick in but the headless:init wont be triggered. 

To trigger a load on the server without restarting the server program. You can call 'radiant:client:load_game_async'. This however, will disconnect the client. The client will need to be restarted. 

# Task List

## Required Features 
These features will set the base of the mod to allow headless server multiplayer functionality.

- [~] Headless Game Saving (Only pre-loaded save games)
- [ ] Auto-Save feature
- [X] Allow headless server to auto-generate world
- [X] Assign first player to become host
- [X] Setup multiplayer settings with auto-generate world
- [ ] On loading of existing save, turn on the multiplayer settings and max_player settings
- [ ] On loading of existing save, delete the 'host' player
- [X] Pass arguments to the executable rather than through json config (There are limits)

## Main Features

- [ ] Client Launcher
- [ ] Game Master mode, allow a player to act as a game master creating their own story by spawning entities and controlling them
- [~] Allow host client to trigger the save functionality (Only pre-loaded save games)
- [X] When client connects, update their multiplayer settings to show multiplayer is enabled on client and the number of max_players
- [ ] Allow client to specify IP address to connect to.
- [ ] Headless Server Side Launcher which allows you to specify world generation settings or the save file to load

## Research Features

- [ ] Is there a C++ callback from lua to start a new server while in game?
- [ ] Is there a C++ callback from lua to have the client connect or restart the connection?
- [ ] Can the host generate a map while the client is connected and allowed to modify the generation or even pick the drop location?

# Notes

Useful notes that may be useful

## General

getmetatable(obj) to see metatable - may be useful for c structs

print(inspect(getmetatable(someuserdata)))

## Command-Line Arguments

Working arguments:
* multiplayer.server.port
* multiplayer.headless.enabled
* multiplayer.headless.saveid
* multiplayer.remote_server.enabled
* multiplayer.remote_server.port

the commented out arguments in server.bat are ones that do not work properly.

multiplayer.remote_server.ip doesn't properly work but it does change the ip if the user config doesn't already contain a value

## World Generation

In the stonehearth mod, there is already a hook for radiant:headless:init. It defaults by retrieving multiplayer.headless.options for the world generation.
Example setting:

    {
        "seed" : 523423443,
        "x" : 0,
        "y" : 0,
        "width" : 10,
        "height" : 8,
        "biome_src" : "temperate",
        "game_mode" : "hard"
    }

## Saving the game
'radiant:client:save_game' only works on client side. There is a check on the server side to only allow 'host' player to execute the save. This is set when the host provider connects or when loaded from the server_metadata.json file for a save_game.

'radiant:server:save' exists, but crashes if called directly to the server. Assembly code kind of indicates this is where the save actually happens.

Maybe able to use dll injection to load in the player_id as host when the game loads.

## Bugs

* if you set multiplayer.remote_server.ip to a value with characters in it, it will lock the game up and not connect to remote server. you can then bind to radiant:new_game to execute your own code on a "black" screen.
* bug with authentication on first few connections

Server Logs:
    |       server |  0 |                  simulation.core | Making authentication request with provider: steam
    |       server |  0 |                  simulation.core | Authentication failed, removing client.
    |       server |  0 |                  simulation.core | Removing client 0
    |       server |  0 |                          network | Transport layer got error on read:2 End of file
    |       server |  0 |                  simulation.core | Making authentication request with provider: steam
    |       server |  0 |                  simulation.core | Authentication failed, removing client.
    |       server |  0 |                  simulation.core | Removing client 0
    |       server |  0 |                          network | Transport layer got error on read:995 The I/O operation has been aborted because of either a thread exit or an application request

Client Logs:
    2018-12-16 13:21:35.709942 |       client |  1 |                          network | client allocating new send buffer (total: 0)
    2018-12-16 13:21:35.710940 |       client |  0 |                      client.core | Authenticating...
    2018-12-16 13:21:36.073690 |       client |  0 |                      client.core | Notified by server of disconnect
    2018-12-16 13:21:36.075684 |       client |  0 |                      client.core | Authentication failed: Invalid auth provider.
    2018-12-16 13:21:36.077679 |       client |  0 |                      client.core | Disconnecting...
    2018-12-16 13:21:36.079674 |       client |  0 |                      client.core | post-abort restart game
    2018-12-16 13:21:36.083663 |       client |  0 |                      client.core | member variables reset
    2018-12-16 13:21:36.085658 |       client |  0 |                      client.core | Connecting to local server...
