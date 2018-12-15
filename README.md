# stonehearth_headless
Stonehearth Headless Server Mod

With v1.1 of Stonehearth, there are a few missing lua code to properly run a headless server. This mod's goal is to fill in the missing gaps.

# Task List

## Required Features 

- [ ] Server-side Saving
- [ ] Auto-Save 
- [ ] Allow headless server to auto-generate world and accept new connections
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