local PhysicsConstants = require(game.ReplicatedStorage.Modules.PhysicsConstants)

-- Duna Template with Mars-like features
local template = Instance.new("Model")
template.Name = "PlanetTemplate_Duna"

-- Core sphere (main body)
local primaryPart = Instance.new("Part")
primaryPart.Name = "PrimaryPart"
primaryPart.Shape = Enum.PartType.Ball
primaryPart.Size = Vector3.new(
    PhysicsConstants.DUNA.RADIUS * 2,
    PhysicsConstants.DUNA.RADIUS * 2,
    PhysicsConstants.DUNA.RADIUS * 2
)
primaryPart.Position = Vector3.new(0, 0, 0)
primaryPart.Anchored = true
primaryPart.BrickColor = BrickColor.new("Dusty Rose")
primaryPart.Material = Enum.Material.Sand
primaryPart.Parent = template

-- Add major canyons
local canyons = {
    {
        name = "VallesMarineris",
        size = Vector3.new(120, 20, 40),
        position = Vector3.new(0, 0, 70),
        scale = Vector3.new(1, 0.2, 1)
    },
    {
        name = "ChasmaBoreale",
        size = Vector3.new(80, 15, 30),
        position = Vector3.new(-50, 50, 0),
        scale = Vector3.new(1, 0.15, 1)
    }
}

-- Create canyon pieces
for _, canyon in ipairs(canyons) do
    local part = Instance.new("Part")
    part.Name = canyon.name
    part.Size = canyon.size
    part.Position = canyon.position
    part.BrickColor = BrickColor.new("Maroon")
    part.Material = Enum.Material.Rock
    -- Use mesh for canyon shape
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.Scale = canyon.scale
    mesh.Parent = part
    part.Parent = template
end

-- Add polar ice caps
local iceCaps = {
    {
        name = "NorthPolarIce",
        size = Vector3.new(60, 10, 60),
        position = Vector3.new(0, 75, 0),
        scale = Vector3.new(1, 0.1, 1)
    },
    {
        name = "SouthPolarIce",
        size = Vector3.new(50, 8, 50),
        position = Vector3.new(0, -75, 0),
        scale = Vector3.new(1, 0.1, 1)
    }
}

-- Create ice cap pieces
for _, cap in ipairs(iceCaps) do
    local part = Instance.new("Part")
    part.Name = cap.name
    part.Size = cap.size
    part.Position = cap.position
    part.BrickColor = BrickColor.new("White")
    part.Material = Enum.Material.Ice
    -- Use mesh for ice cap shape
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.Scale = cap.scale
    mesh.Parent = part
    part.Parent = template
end

-- Add thin atmosphere
for i = 1, 2 do
    local atmosphere = Instance.new("Part")
    atmosphere.Name = "AtmosphereLayer" .. i
    atmosphere.Shape = Enum.PartType.Ball
    atmosphere.Size = Vector3.new(
        PhysicsConstants.DUNA.RADIUS * 2 + (PhysicsConstants.DUNA.ATMOSPHERE_HEIGHT * i/2),
        PhysicsConstants.DUNA.RADIUS * 2 + (PhysicsConstants.DUNA.ATMOSPHERE_HEIGHT * i/2),
        PhysicsConstants.DUNA.RADIUS * 2 + (PhysicsConstants.DUNA.ATMOSPHERE_HEIGHT * i/2)
    )
    atmosphere.Position = Vector3.new(0, 0, 0)
    atmosphere.Transparency = 0.85 + (i * 0.05)
    atmosphere.BrickColor = BrickColor.new("Terra Cotta")
    atmosphere.Material = Enum.Material.ForceField
    atmosphere.CanCollide = false
    atmosphere.Parent = template
end

template.PrimaryPart = primaryPart

return template
