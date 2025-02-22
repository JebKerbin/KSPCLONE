local GameServer = script.Parent.GameServer
local PlayerStats = require(game.ReplicatedStorage.Modules.PlayerStats)

-- Wait for game to load
game.Loaded:Wait()

-- Store player stats instances
local playerStatsMap = {}

-- Handle player joining to set up their spacecraft and stats
game.Players.PlayerAdded:Connect(function(player)
    print("[ServerInit] Player joined:", player.Name)

    -- Initialize player stats
    local stats = PlayerStats.new(player)
    playerStatsMap[player.UserId] = stats
    print("[ServerInit] Initialized stats for:", player.Name)

    -- Wait for character to load
    player.CharacterAdded:Connect(function(character)
        print("[ServerInit] Character loaded for:", player.Name)

        -- Find command pod in workspace
        local commandPod = workspace:FindFirstChild("CommandPod")
        if commandPod then
            print("[ServerInit] Found command pod, creating spacecraft for:", player.Name)
            -- Create new spacecraft with command pod
            local SpacecraftSystem = require(game.ReplicatedStorage.Modules.SpacecraftSystem)
            local spacecraft = SpacecraftSystem.new(commandPod)

            -- Link spacecraft to player stats
            spacecraft.stats = playerStatsMap[player.UserId]
            print("[ServerInit] Linked spacecraft to player stats for:", player.Name)

            -- Register spacecraft with GameServer
            GameServer:RegisterSpacecraft(spacecraft, player)
        else
            warn("[ServerInit] No command pod found for:", player.Name)
        end
    end)
end)

-- Handle player leaving
game.Players.PlayerRemoving:Connect(function(player)
    print("[ServerInit] Player leaving:", player.Name)

    -- Save and cleanup player stats
    if playerStatsMap[player.UserId] then
        playerStatsMap[player.UserId]:save()
        playerStatsMap[player.UserId] = nil
        print("[ServerInit] Saved and cleaned up stats for:", player.Name)
    end
end)

print("[ServerInit] Server initialization complete")