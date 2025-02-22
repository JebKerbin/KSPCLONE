local PhysicsService = game:GetService("PhysicsService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local OrbitalMechanics = require(game.ReplicatedStorage.Modules.OrbitalMechanics)
local PhysicsConstants = require(game.ReplicatedStorage.Modules.PhysicsConstants)
local SpacecraftSystem = require(game.ReplicatedStorage.Modules.SpacecraftSystem)
local PlanetTemplateGenerator = require(game.ReplicatedStorage.Assets.Planets.PlanetTemplateGenerator)

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

local _GameServer = {
    celestialBodies = {},
    activeSpacecraft = {}
}

-- Update findCelestialBodies to handle all planets and moons
local function findCelestialBodies()
    local bodies = {}
    local planetFolder = Instance.new("Folder")
    planetFolder.Name = "CelestialBodies"
    planetFolder.Parent = workspace

    -- List of all celestial bodies to create
    local celestialBodies = {
        "KERBOL", "MOHO", "EVE", "GILLY", "KERBIN", "MUN", "MINMUS",
        "DUNA", "IKE", "DRES", "JOOL", "LAYTHE", "VALL", "TYLO",
        "BOP", "POL", "EELOO", "OVIN", "GARGANTUA", "GLUMO"
    }

    print("[GameServer] Starting celestial body creation")

    for _, bodyName in ipairs(celestialBodies) do
        print("[GameServer] Creating", bodyName)
        local planet = PlanetTemplateGenerator.createTemplate(bodyName)
        planet.Name = bodyName
        planet.Parent = planetFolder
        bodies[bodyName] = planet

        -- Create gravitational field
        local gravityField = Instance.new("BodyForce")
        gravityField.Name = "GravityField"
        gravityField.Parent = planet

        print(string.format("[GameServer] Created %s at position: %s", 
            bodyName, tostring(planet.PrimaryPart.Position)))
    end

    return bodies
end

function _GameServer:Initialize()
    print("[GameServer] Starting initialization...")
    self.celestialBodies = findCelestialBodies()

    -- Create test spacecraft
    local commandPod = Instance.new("Part")
    commandPod.Name = "CommandPod"
    commandPod.Position = Vector3.new(0, PhysicsConstants.KERBIN.RADIUS + 100, 0) -- Start 100 studs above Kerbin
    commandPod.Size = Vector3.new(2, 3, 2)
    commandPod.Anchored = false
    commandPod.Parent = game.Workspace
    print("[GameServer] Created test command pod at height:", commandPod.Position.Y)

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

    print("[GameServer] Initialization complete")
end

function _GameServer:GetPlayerSpacecraft(player)
    return self.activeSpacecraft[player.UserId]
end

function _GameServer:UpdatePhysics(dt)
    -- Update each spacecraft
    for _, spacecraft in pairs(self.activeSpacecraft) do
        -- Calculate gravitational forces from each celestial body
        local totalForce = Vector3.new(0, 0, 0)

        for name, body in pairs(self.celestialBodies) do
            if body then
                local force = OrbitalMechanics.calculateGravitationalForce(
                    PhysicsConstants[name].MASS,
                    spacecraft.mass,
                    body.PrimaryPart.Position,
                    spacecraft.parts[1].Position
                )
                totalForce = totalForce + force
            end
        end

        -- Apply forces to spacecraft
        local bodyForce = spacecraft.parts[1]:FindFirstChild("EngineForce")
        if bodyForce then
            bodyForce.Force = totalForce
        end
    end
end

function _GameServer:RegisterSpacecraft(spacecraft, player)
    print("[GameServer] Registering spacecraft for player:", player.Name)
    self.activeSpacecraft[player.UserId] = spacecraft

    -- Create engine force
    local engineForce = Instance.new("BodyForce")
    engineForce.Name = "EngineForce"
    engineForce.Parent = spacecraft.parts[1]
end

-- Initialize the game server immediately
_GameServer:Initialize()