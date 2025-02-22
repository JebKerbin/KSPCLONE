local PhysicsConstants = require(game.ReplicatedStorage.Modules.PhysicsConstants)

-- Eve Template with thick atmosphere and surface features
local template = Instance.new("Model")
template.Name = "PlanetTemplate_Eve"

-- Core sphere (main body)
local primaryPart = Instance.new("Part")
primaryPart.Name = "PrimaryPart"
primaryPart.Shape = Enum.PartType.Ball
primaryPart.Size = Vector3.new(
    PhysicsConstants.EVE.RADIUS * 2,
    PhysicsConstants.EVE.RADIUS * 2,
    PhysicsConstants.EVE.RADIUS * 2
)
primaryPart.Position = Vector3.new(0, 0, 0)
primaryPart.Anchored = true
primaryPart.BrickColor = BrickColor.new("Royal purple")
primaryPart.Material = Enum.Material.Rock
primaryPart.Parent = template

-- Add terrain features (mountains and valleys)
local terrainFeatures = {
    {
        name = "MountainRange1",
        size = Vector3.new(250, 40, 180),
        position = Vector3.new(-100, 150, 0),
        color = "Dark purple",
        material = Enum.Material.Rock
    },
    {
        name = "MountainRange2",
        size = Vector3.new(200, 35, 160),
        position = Vector3.new(80, -140, 30),
        color = "Royal purple",
        material = Enum.Material.Rock
    },
    {
        name = "Valley1",
        size = Vector3.new(300, 20, 200),
        position = Vector3.new(0, 0, 170),
        color = "Dark indigo",
        material = Enum.Material.Slate
    }
}

-- Create terrain pieces
for _, feature in ipairs(terrainFeatures) do
    local part = Instance.new("Part")
    part.Name = feature.name
    part.Size = feature.size
    part.Position = feature.position
    part.BrickColor = BrickColor.new(feature.color)
    part.Material = feature.material
    -- Use mesh for terrain shaping
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.Scale = Vector3.new(1, 0.3, 1)
    mesh.Parent = part
    part.Parent = template
end

-- Add liquid surface areas (oceans)
local oceans = {
    {
        name = "Ocean_North",
        size = Vector3.new(280, 10, 280),
        position = Vector3.new(0, 160, 0),
        scale = Vector3.new(1, 0.05, 1)
    },
    {
        name = "Ocean_South",
        size = Vector3.new(260, 10, 260),
        position = Vector3.new(0, -150, 0),
        scale = Vector3.new(1, 0.05, 1)
    }
}

-- Create ocean pieces
for _, ocean in ipairs(oceans) do
    local part = Instance.new("Part")
    part.Name = ocean.name
    part.Size = ocean.size
    part.Position = ocean.position
    part.BrickColor = BrickColor.new("Deep blue")
    part.Material = Enum.Material.Neon
    part.Transparency = 0.3
    -- Use mesh for ocean surface
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.Scale = ocean.scale
    mesh.Parent = part
    part.Parent = template
end

-- Add thick atmosphere layers
for i = 1, 4 do
    local atmosphere = Instance.new("Part")
    atmosphere.Name = "AtmosphereLayer" .. i
    atmosphere.Shape = Enum.PartType.Ball
    atmosphere.Size = Vector3.new(
        PhysicsConstants.EVE.RADIUS * 2 + (PhysicsConstants.EVE.ATMOSPHERE_HEIGHT * i/2),
        PhysicsConstants.EVE.RADIUS * 2 + (PhysicsConstants.EVE.ATMOSPHERE_HEIGHT * i/2),
        PhysicsConstants.EVE.RADIUS * 2 + (PhysicsConstants.EVE.ATMOSPHERE_HEIGHT * i/2)
    )
    atmosphere.Position = Vector3.new(0, 0, 0)
    atmosphere.Transparency = 0.75 + (i * 0.05)
    atmosphere.BrickColor = BrickColor.new("Light purple")
    atmosphere.Material = Enum.Material.ForceField
    atmosphere.CanCollide = false
    atmosphere.Parent = template
end

template.PrimaryPart = primaryPart

return template
