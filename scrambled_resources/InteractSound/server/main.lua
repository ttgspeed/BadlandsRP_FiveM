
------
-- Interaction Sounds by Scott
-- Version: v0.0.1
-- Path: server/main.lua
--
-- Allows sounds to be played on single clients, all clients, or all clients within
-- a specific range from the entity to which the sound has been created. Triggers
-- client events only. Used to trigger sounds on other clients from the client or
-- server without having to pass directly to another client.
------

------
-- RegisterServerEvent InteractSound_SV:PlayOnOne
-- Triggers -> ClientEvent InteractSound_CL:PlayOnOne
--
-- @param clientNetId  - The network id of the client that the sound should be played on.
-- @param soundFile    - The name of the soundfile within the client/html/sounds/ folder.
--                     - Can also specify a folder/sound file.
-- @param soundVolume  - The volume at which the soundFile should be played. Nil or don't
--                     - provide it for the default of standardVolumeOutput. Should be between
--                     - 0.1 to 1.0.
--                     - Can also specify a folder/sound file.
--
-- Starts playing a sound locally on a single client.
------
RegisterServerEvent('c2921d66-7900-4922-addd-4c7da9c532e5')
AddEventHandler('c2921d66-7900-4922-addd-4c7da9c532e5', function(clientNetId, soundFile, soundVolume)
    TriggerClientEvent('7fc89954-c170-42e8-8cf3-550d52ae0459', clientNetId, soundFile, soundVolume)
end)

------
-- RegisterServerEvent InteractSound_SV:PlayOnSource
-- Triggers -> ClientEvent InteractSound_CL:PlayOnSource
--
-- @param soundFile    - The name of the soundfile within the client/html/sounds/ folder.
--                     - Can also specify a folder/sound file.
-- @param soundVolume  - The volume at which the soundFile should be played. Nil or don't
--                     - provide it for the default of standardVolumeOutput. Should be between
--                     - 0.1 to 1.0.
--                     - Can also specify a folder/sound file.
--
-- Starts playing a sound locally on a single client, which is the source of the event.
------
RegisterServerEvent('3fc61ce0-a766-4508-9fa9-5374b05f5323')
AddEventHandler('3fc61ce0-a766-4508-9fa9-5374b05f5323', function(soundFile, soundVolume)
    TriggerClientEvent('7fc89954-c170-42e8-8cf3-550d52ae0459', source, soundFile, soundVolume)
end)

------
-- RegisterServerEvent InteractSound_SV:PlayOnAll
-- Triggers -> ClientEvent InteractSound_CL:PlayOnAll
--
-- @param soundFile     - The name of the soundfile within the client/html/sounds/ folder.
--                      - Can also specify a folder/sound file.
-- @param soundVolume   - The volume at which the soundFile should be played. Nil or don't
--                      - provide it for the default of standardVolumeOutput. Should be between
--                      - 0.1 to 1.0.
--
-- Starts playing a sound on all clients who are online in the server.
------
RegisterServerEvent('93d713a9-726d-4d86-b362-b1b10104c1fb')
AddEventHandler('93d713a9-726d-4d86-b362-b1b10104c1fb', function(soundFile, soundVolume)
    TriggerClientEvent('cd3933be-0c3f-4da0-8229-786f30dcac3b', -1, soundFile, soundVolume)
end)

------
-- RegisterServerEvent InteractSound_SV:PlayWithinDistance
-- Triggers -> ClientEvent InteractSound_CL:PlayWithinDistance
--
-- @param playOnEntity    - The entity network id (will be converted from net id to entity on client)
--                        - of the entity for which the max distance is to be drawn from.
-- @param maxDistance     - The maximum float distance (client uses Vdist) to allow the player to
--                        - hear the soundFile being played.
-- @param soundFile       - The name of the soundfile within the client/html/sounds/ folder.
--                        - Can also specify a folder/sound file.
-- @param soundVolume     - The volume at which the soundFile should be played. Nil or don't
--                        - provide it for the default of standardVolumeOutput. Should be between
--                        - 0.1 to 1.0.
--
-- Starts playing a sound on a client if the client is within the specificed maxDistance from the playOnEntity.
-- @TODO Change sound volume based on the distance the player is away from the playOnEntity.
------
RegisterServerEvent('0ff9286b-c62f-4d95-adc9-3c41dfa844d6')
AddEventHandler('0ff9286b-c62f-4d95-adc9-3c41dfa844d6', function(maxDistance, soundFile, soundVolume)
    TriggerClientEvent('0d81b737-26e2-4af1-b5ed-4c573f93c745', -1, source, maxDistance, soundFile, soundVolume)
end)
