local PhysicsService = game:GetService("PhysicsService")
local RunService = game:GetService("RunService")

local OrbitalMechanics = require(game.ReplicatedStorage.Modules.OrbitalMechanics)
local PhysicsConstants = require(game.ReplicatedStorage.Modules.PhysicsConstants)

local GameServer = {}

-- Find celestial bodies in workspace
local function findCelestialBodies()
    local bodies = {
        Kerbin = nil,
        Mun = nil,
        Minmus = nil
    }
    
    for _, obj in ipairs(game.Workspace:GetChildren()) do
        if obj.Name == "Kerbin" or obj.Name == "Mun" or obj.Name == "Minmus" then
            bodies[obj.Name] = obj
        end
    end
    
    return bodies
end

function GameServer:Initialize()
    self.celestialBodies = findCelestialBodies()
    self.activeSpacecraft = {}
    
    -- Set up physics properties for celestial bodies
    for name, body in pairs(self.celestialBodies) do
        local mass = PhysicsConstants[name].MASS
        body.Anchored = true
        
        -- Create gravitational field
        local gravityField = Instance.new("BodyForce")
        gravityField.Name = "GravityField"
        gravityField.Parent = body
    end
    
    -- Start physics update loop
    RunService.Heartbeat:Connect(function(dt)
        self:UpdatePhysics(dt)
    end)
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

function GameServer:RegisterSpacecraft(spacecraft)
    table.insert(self.activeSpacecraft, spacecraft)
    
    -- Create engine force
    local engineForce = Instance.new("BodyForce")
    engineForce.Name = "EngineForce"
    engineForce.Parent = spacecraft.parts[1]
end

return GameServer
