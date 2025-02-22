local GameServer = require(script.Parent.GameServer)

-- Wait for game to load
game.Loaded:Wait()

-- Initialize the game server
GameServer:Initialize()

-- Handle player joining to set up their spacecraft
game.Players.PlayerAdded:Connect(function(player)
    print("[ServerInit] Player joined:", player.Name)
    
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
            
            -- Register spacecraft with GameServer
            GameServer:RegisterSpacecraft(spacecraft, player)
        else
            warn("[ServerInit] No command pod found for:", player.Name)
        end
    end)
end)

print("[ServerInit] Server initialization complete")
