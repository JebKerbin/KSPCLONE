local PhysicsConstants = require(game.ReplicatedStorage.Modules.PhysicsConstants)

-- Laythe Template - Ocean Moon
local template = Instance.new("Model")
template.Name = "PlanetTemplate_Laythe"

-- Core sphere (main body - ocean surface)
local primaryPart = Instance.new("Part")
primaryPart.Name = "PrimaryPart"
primaryPart.Shape = Enum.PartType.Ball
primaryPart.Size = Vector3.new(
    PhysicsConstants.LAYTHE.RADIUS * 2,
    PhysicsConstants.LAYTHE.RADIUS * 2,
    PhysicsConstants.LAYTHE.RADIUS * 2
)
primaryPart.Position = Vector3.new(0, 0, 0)
primaryPart.Anchored = true
primaryPart.BrickColor = BrickColor.new("Deep blue")
primaryPart.Material = Enum.Material.Glass
primaryPart.Parent = template

-- Add island continents
local islands = {
    {
        name = "MainArchipelago",
        size = Vector3.new(150, 20, 120),
        position = Vector3.new(-60, 100, 0),
        color = "Reddish brown",
        material = Enum.Material.Grass
    },
    {
        name = "NorthernIslands",
        size = Vector3.new(100, 15, 80),
        position = Vector3.new(40, 110, 40),
        color = "Brown",
        material = Enum.Material.Grass
    },
    {
        name = "SouthernContinent",
        size = Vector3.new(180, 25, 140),
        position = Vector3.new(20, -90, -20),
        color = "Dark orange",
        material = Enum.Material.Grass
    }
}

-- Create island pieces
for _, island in ipairs(islands) do
    local part = Instance.new("Part")
    part.Name = island.name
    part.Size = island.size
    part.Position = island.position
    part.BrickColor = BrickColor.new(island.color)
    part.Material = island.material
    -- Use mesh for terrain shaping
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.Scale = Vector3.new(1, 0.3, 1)
    mesh.Parent = part
    part.Parent = template
end

-- Add ocean waves (semi-transparent layers)
for i = 1, 2 do
    local waves = Instance.new("Part")
    waves.Name = "OceanLayer" .. i
    waves.Shape = Enum.PartType.Ball
    waves.Size = Vector3.new(
        PhysicsConstants.LAYTHE.RADIUS * 2.02,
        PhysicsConstants.LAYTHE.RADIUS * 2.02,
        PhysicsConstants.LAYTHE.RADIUS * 2.02
    )
    waves.Position = Vector3.new(0, 0, 0)
    waves.Transparency = 0.8 + (i * 0.1)
    waves.BrickColor = BrickColor.new("Cyan")
    waves.Material = Enum.Material.Glass
    waves.CanCollide = false
    waves.Parent = template
end

-- Add atmosphere layers
for i = 1, 3 do
    local atmosphere = Instance.new("Part")
    atmosphere.Name = "AtmosphereLayer" .. i
    atmosphere.Shape = Enum.PartType.Ball
    atmosphere.Size = Vector3.new(
        PhysicsConstants.LAYTHE.RADIUS * 2 + (PhysicsConstants.LAYTHE.ATMOSPHERE_HEIGHT * i/2),
        PhysicsConstants.LAYTHE.RADIUS * 2 + (PhysicsConstants.LAYTHE.ATMOSPHERE_HEIGHT * i/2),
        PhysicsConstants.LAYTHE.RADIUS * 2 + (PhysicsConstants.LAYTHE.ATMOSPHERE_HEIGHT * i/2)
    )
    atmosphere.Position = Vector3.new(0, 0, 0)
    atmosphere.Transparency = 0.85 + (i * 0.05)
    atmosphere.BrickColor = BrickColor.new("Light blue")
    atmosphere.Material = Enum.Material.ForceField
    atmosphere.CanCollide = false
    atmosphere.Parent = template
end

template.PrimaryPart = primaryPart

return template
