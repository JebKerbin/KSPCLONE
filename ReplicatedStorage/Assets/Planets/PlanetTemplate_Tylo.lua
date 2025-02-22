local PhysicsConstants = require(game.ReplicatedStorage.Modules.PhysicsConstants)

-- Tylo Template - Large Rocky Moon
local template = Instance.new("Model")
template.Name = "PlanetTemplate_Tylo"

-- Core sphere (main body)
local primaryPart = Instance.new("Part")
primaryPart.Name = "PrimaryPart"
primaryPart.Shape = Enum.PartType.Ball
primaryPart.Size = Vector3.new(
    PhysicsConstants.TYLO.RADIUS * 2,
    PhysicsConstants.TYLO.RADIUS * 2,
    PhysicsConstants.TYLO.RADIUS * 2
)
primaryPart.Position = Vector3.new(0, 0, 0)
primaryPart.Anchored = true
primaryPart.BrickColor = BrickColor.new("Stone grey")
primaryPart.Material = Enum.Material.Rock
primaryPart.Parent = template

-- Add major impact basins
local basins = {
    {
        name = "Basin_Tycho",
        size = Vector3.new(180, 30, 180),
        position = Vector3.new(100, 50, 0),
        scale = Vector3.new(1, 0.15, 1)
    },
    {
        name = "Basin_Copernicus",
        size = Vector3.new(150, 25, 150),
        position = Vector3.new(-90, -40, 60),
        scale = Vector3.new(1, 0.12, 1)
    },
    {
        name = "Basin_Clavius",
        size = Vector3.new(200, 35, 200),
        position = Vector3.new(30, 120, 40),
        scale = Vector3.new(1, 0.18, 1)
    }
}

-- Create impact basin pieces
for _, basin in ipairs(basins) do
    local part = Instance.new("Part")
    part.Name = basin.name
    part.Size = basin.size
    part.Position = basin.position
    part.BrickColor = BrickColor.new("Dark stone grey")
    part.Material = Enum.Material.Slate
    -- Use mesh for basin shape
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.Cylinder
    mesh.Scale = basin.scale
    mesh.Parent = part
    part.Parent = template
end

-- Add highland regions
local highlands = {
    {
        name = "Highland_North",
        size = Vector3.new(250, 20, 200),
        position = Vector3.new(0, 140, 0),
        color = "Sand"
    },
    {
        name = "Highland_South",
        size = Vector3.new(220, 18, 180),
        position = Vector3.new(40, -130, 20),
        color = "Brick yellow"
    }
}

-- Create highland pieces
for _, highland in ipairs(highlands) do
    local part = Instance.new("Part")
    part.Name = highland.name
    part.Size = highland.size
    part.Position = highland.position
    part.BrickColor = BrickColor.new(highland.color)
    part.Material = Enum.Material.Rock
    -- Use mesh for terrain shaping
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.Scale = Vector3.new(1, 0.2, 1)
    mesh.Parent = part
    part.Parent = template
end

-- Add smaller craters and surface details
for i = 1, 15 do
    local crater = Instance.new("Part")
    crater.Name = "Crater_" .. i
    crater.Shape = Enum.PartType.Cylinder
    crater.Size = Vector3.new(30 + math.random(-10, 10), 8, 30 + math.random(-10, 10))
    -- Distribute craters around the surface
    local angle = (i / 15) * math.pi * 2
    local radius = math.random(80, 120)
    crater.Position = Vector3.new(
        math.cos(angle) * radius,
        math.sin(angle) * radius,
        math.random(-50, 50)
    )
    crater.BrickColor = BrickColor.new("Medium stone grey")
    crater.Material = Enum.Material.Rock
    crater.Parent = template
end

template.PrimaryPart = primaryPart

return template
