# stonehearth_mpe 
Stonehearth Multiplayer Enhancements

The goal of this mod is to add headless server capabilities.

# Task List

## Required Features 

- [ ] Server-side Saving
- [ ] Auto-Save 
- [X] Allow headless server to auto-generate world and accept new connections
- [ ] Assign first player to become host
- [ ] Properly setup a multiplayer game when using auto-generation
- [ ] Get the config settings that are possible for auto generation
- [ ] On loading of existing save, turn on the multiplayer settings and max_player settings
- [ ] Pull max_player from "multiplayer.server.headless.max_players"

## User-Friendly Features

- [X] Pass arguments to the executable rather than through json config
- [ ] Allow clients to trigger the save functionality
- [ ] When client connects, update their multiplayer settings to show multiplayer is enabled on client and the number of max_players
- [ ] Allow client to specify IP address to connect to.
- [ ] Headless Server Side Launcher which allows you to specify world generation settings or the save file to load

## Research Features

- [ ] Is there a C++ callback from lua to start a new server while in game?
- [ ] Is there a C++ callback from lua to have the client connect or restart the connection?
- [ ] Can the host generate a map while the client is connected and allowed to modify the generation or even pick the drop location?
- [ ] ...


# Notes
getmetatable(obj) to see metatable

Any calls to _radiant.sim.get_host_player_id() need to be patched to refer to stonehearth_mpe:get_host_player_id()
Any calls to _radiant.client.is_authenticated_as_host needs to be patched to refer to stonehearth_mpe:is_authenticated_as_host()

print(inspect(getmetatable(someuserdata)))