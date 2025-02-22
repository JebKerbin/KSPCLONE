local PhysicsService = game:GetService("PhysicsService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local OrbitalMechanics = require(game.ReplicatedStorage.Modules.OrbitalMechanics)
local PhysicsConstants = require(game.ReplicatedStorage.Modules.PhysicsConstants)
local SpacecraftSystem = require(game.ReplicatedStorage.Modules.SpacecraftSystem)

-- Create RemoteEvents for spacecraft control
local Events = {
    UpdateThrottle = Instance.new("RemoteEvent"),
    UpdateRotation = Instance.new("RemoteEvent"),
    ToggleSAS = Instance.new("RemoteEvent"),
    Stage = Instance.new("RemoteEvent")
}

for name, event in pairs(Events) do
    event.Name = name
    event.Parent = ReplicatedStorage
end

local GameServer = {}

-- Find celestial bodies in ReplicatedStorage
local function findCelestialBodies()
    local bodies = {
        Kerbin = nil,
        Mun = nil,
        Minmus = nil
    }

    local planetsFolder = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Planets")
    print("[GameServer] Looking for planet templates in:", planetsFolder:GetFullName())

    for name in pairs(bodies) do
        local template = planetsFolder:FindFirstChild("PlanetTemplate_" .. name)
        if template then
            -- Clone the template to workspace
            local planet = template:Clone()
            planet.Name = name
            planet.Parent = game.Workspace
            bodies[name] = planet
            print("[GameServer] Found and cloned planet:", name)
        else
            warn("[GameServer] Could not find template for planet:", name)
        end
    end

    return bodies
end

function GameServer:Initialize()
    self.celestialBodies = findCelestialBodies()
    self.activeSpacecraft = {}
    print("[GameServer] Initialized")

    -- Set up physics properties for celestial bodies
    for name, body in pairs(self.celestialBodies) do
        local mass = PhysicsConstants[name].MASS
        body.Anchored = true
        print("[GameServer] Set up physics for:", name)

        -- Create gravitational field
        local gravityField = Instance.new("BodyForce")
        gravityField.Name = "GravityField"
        gravityField.Parent = body
    end

    -- Create test spacecraft
    local commandPod = Instance.new("Part")
    commandPod.Name = "CommandPod"
    commandPod.Position = Vector3.new(0, 100, 0) -- Start 100 studs above origin
    commandPod.Size = Vector3.new(2, 3, 2)
    commandPod.Anchored = false
    commandPod.Parent = game.Workspace
    print("[GameServer] Created test command pod")

    -- Set up event handlers
    Events.UpdateThrottle.OnServerEvent:Connect(function(player, throttle)
        print("[GameServer] Received throttle update from", player.Name, ":", throttle)
        local spacecraft = self:GetPlayerSpacecraft(player)
        if spacecraft then
            spacecraft:applyThrust(throttle)
        end
    end)

    Events.UpdateRotation.OnServerEvent:Connect(function(player, rotation)
        print("[GameServer] Received rotation update from", player.Name, ":", rotation)
        local spacecraft = self:GetPlayerSpacecraft(player)
        if spacecraft then
            spacecraft:applyRotation(rotation)
        end
    end)

    Events.ToggleSAS.OnServerEvent:Connect(function(player)
        print("[GameServer] Received SAS toggle from", player.Name)
        local spacecraft = self:GetPlayerSpacecraft(player)
        if spacecraft then
            spacecraft.sasEnabled = not spacecraft.sasEnabled
        end
    end)

    Events.Stage.OnServerEvent:Connect(function(player)
        print("[GameServer] Received stage command from", player.Name)
        local spacecraft = self:GetPlayerSpacecraft(player)
        if spacecraft then
            spacecraft:stage()
        end
    end)

    -- Start physics update loop
    RunService.Heartbeat:Connect(function(dt)
        self:UpdatePhysics(dt)
    end)
end

function GameServer:GetPlayerSpacecraft(player)
    -- Return the spacecraft associated with the player
    return self.activeSpacecraft[player.UserId]
end

function GameServer:UpdatePhysics(dt)
    -- Update each spacecraft
    for _, spacecraft in pairs(self.activeSpacecraft) do
        -- Calculate gravitational forces from each celestial body
        local totalForce = Vector3.new(0, 0, 0)

        for name, body in pairs(self.celestialBodies) do
            local force = OrbitalMechanics.calculateGravitationalForce(
                PhysicsConstants[name].MASS,
                spacecraft.mass,
                body.Position,
                spacecraft.parts[1].Position
            )
            totalForce = totalForce + force
        end

        -- Apply forces to spacecraft
        local bodyForce = spacecraft.parts[1]:FindFirstChild("EngineForce")
        if bodyForce then
            bodyForce.Force = totalForce
        end
    end
end

function GameServer:RegisterSpacecraft(spacecraft, player)
    print("[GameServer] Registering spacecraft for player:", player.Name)
    self.activeSpacecraft[player.UserId] = spacecraft

    -- Create engine force
    local engineForce = Instance.new("BodyForce")
    engineForce.Name = "EngineForce"
    engineForce.Parent = spacecraft.parts[1]
end

return GameServer