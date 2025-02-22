local PhysicsConstants = require(game.ReplicatedStorage.Modules.PhysicsConstants)

-- Kerbin Template with multiple pieces
local template = Instance.new("Model")
template.Name = "PlanetTemplate_Kerbin"

-- Core sphere (main body)
local primaryPart = Instance.new("Part")
primaryPart.Name = "PrimaryPart"
primaryPart.Shape = Enum.PartType.Ball
primaryPart.Size = Vector3.new(
    PhysicsConstants.KERBIN.RADIUS * 2,
    PhysicsConstants.KERBIN.RADIUS * 2,
    PhysicsConstants.KERBIN.RADIUS * 2
)
primaryPart.Position = Vector3.new(0, 0, 0)
primaryPart.Anchored = true
primaryPart.BrickColor = BrickColor.new("Earth blue")
primaryPart.Material = Enum.Material.Slate
primaryPart.Parent = template

-- Add continents (multiple pieces)
local continents = {
    {
        name = "Continent_KSC",
        size = Vector3.new(200, 15, 150),
        position = Vector3.new(-50, 145, 0),
        color = "Brick yellow",
        material = Enum.Material.Grass
    },
    {
        name = "Continent_North",
        size = Vector3.new(180, 10, 160),
        position = Vector3.new(20, 120, 40),
        color = "Dark green",
        material = Enum.Material.Grass
    },
    {
        name = "Continent_South",
        size = Vector3.new(220, 12, 140),
        position = Vector3.new(30, -130, -20),
        color = "Olive",
        material = Enum.Material.Grass
    }
}

-- Create continent pieces
for _, continent in ipairs(continents) do
    local part = Instance.new("Part")
    part.Name = continent.name
    part.Size = continent.size
    part.Position = continent.position
    part.BrickColor = BrickColor.new(continent.color)
    part.Material = continent.material
    -- Use custom mesh to make continents follow planet curvature
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.Scale = Vector3.new(1, 0.2, 1) -- Flatten the mesh slightly
    mesh.Parent = part
    part.Parent = template
end

-- Add ice caps
local iceCaps = {
    {
        name = "NorthPole",
        position = Vector3.new(0, 145, 0),
        scale = Vector3.new(0.3, 0.1, 0.3)
    },
    {
        name = "SouthPole",
        position = Vector3.new(0, -145, 0),
        scale = Vector3.new(0.25, 0.1, 0.25)
    }
}

for _, cap in ipairs(iceCaps) do
    local part = Instance.new("Part")
    part.Name = cap.name
    part.Shape = Enum.PartType.Ball
    part.Size = Vector3.new(100, 30, 100)
    part.Position = cap.position
    part.BrickColor = BrickColor.new("White")
    part.Material = Enum.Material.Ice
    -- Use scaling to shape the ice caps
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.Sphere
    mesh.Scale = cap.scale
    mesh.Parent = part
    part.Parent = template
end

-- Add clouds (semi-transparent layers)
for i = 1, 3 do
    local clouds = Instance.new("Part")
    clouds.Name = "CloudLayer" .. i
    clouds.Shape = Enum.PartType.Ball
    clouds.Size = Vector3.new(
        PhysicsConstants.KERBIN.RADIUS * 2.05, -- Slightly larger than planet
        PhysicsConstants.KERBIN.RADIUS * 2.05,
        PhysicsConstants.KERBIN.RADIUS * 2.05
    )
    clouds.Position = Vector3.new(0, 0, 0)
    clouds.Transparency = 0.7 + (i * 0.1) -- Increasing transparency for each layer
    clouds.BrickColor = BrickColor.new("White")
    clouds.Material = Enum.Material.SmoothPlastic
    clouds.CanCollide = false
    clouds.Parent = template
end

template.PrimaryPart = primaryPart

return template