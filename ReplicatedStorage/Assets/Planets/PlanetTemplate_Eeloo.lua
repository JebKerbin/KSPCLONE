local PhysicsConstants = require(game.ReplicatedStorage.Modules.PhysicsConstants)

-- Eeloo Template - Distant Icy Dwarf Planet
local template = Instance.new("Model")
template.Name = "PlanetTemplate_Eeloo"

-- Core sphere (main body)
local primaryPart = Instance.new("Part")
primaryPart.Name = "PrimaryPart"
primaryPart.Shape = Enum.PartType.Ball
primaryPart.Size = Vector3.new(
    PhysicsConstants.EELOO.RADIUS * 2,
    PhysicsConstants.EELOO.RADIUS * 2,
    PhysicsConstants.EELOO.RADIUS * 2
)
primaryPart.Position = Vector3.new(0, 0, 0)
primaryPart.Anchored = true
primaryPart.BrickColor = BrickColor.new("Institutional white")
primaryPart.Material = Enum.Material.Ice
primaryPart.Parent = template

-- Add major ice plains
local icePlains = {
    {
        name = "Sputnik_Planitia",
        size = Vector3.new(100, 5, 80),
        position = Vector3.new(0, 50, 0),
        scale = Vector3.new(1, 0.1, 1)
    },
    {
        name = "Tombaugh_Regio",
        size = Vector3.new(90, 4, 70),
        position = Vector3.new(-40, -30, 20),
        scale = Vector3.new(1, 0.08, 1)
    }
}

-- Create ice plain pieces
for _, plain in ipairs(icePlains) do
    local part = Instance.new("Part")
    part.Name = plain.name
    part.Size = plain.size
    part.Position = plain.position
    part.BrickColor = BrickColor.new("White")
    part.Material = Enum.Material.Ice
    -- Use mesh for smooth plains
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.Scale = plain.scale
    mesh.Parent = part
    part.Parent = template
end

-- Add mountain ranges
local mountains = {
    {
        name = "Norgay_Montes",
        size = Vector3.new(70, 20, 40),
        position = Vector3.new(40, 20, 0),
        color = "Light stone grey"
    },
    {
        name = "Hillary_Montes",
        size = Vector3.new(60, 15, 35),
        position = Vector3.new(-30, -40, -10),
        color = "Medium stone grey"
    }
}

-- Create mountain pieces
for _, mountain in ipairs(mountains) do
    local part = Instance.new("Part")
    part.Name = mountain.name
    part.Size = mountain.size
    part.Position = mountain.position
    part.BrickColor = BrickColor.new(mountain.color)
    part.Material = Enum.Material.Rock
    -- Use mesh for mountain shape
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.Scale = Vector3.new(1, 0.4, 1)
    mesh.Parent = part
    part.Parent = template
end

-- Add surface details (craters and cracks)
for i = 1, 10 do
    local detail = Instance.new("Part")
    detail.Name = "SurfaceDetail_" .. i
    detail.Shape = i % 2 == 0 and Enum.PartType.Cylinder or Enum.PartType.Block
    detail.Size = Vector3.new(15 + math.random(-5, 5), 4, 15 + math.random(-5, 5))
    -- Distribute details evenly
    local angle = (i / 10) * math.pi * 2
    local radius = math.random(30, 50)
    detail.Position = Vector3.new(
        math.cos(angle) * radius,
        math.sin(angle) * radius,
        math.random(-20, 20)
    )
    detail.BrickColor = BrickColor.new(i % 2 == 0 and "Light stone grey" or "Institutional white")
    detail.Material = i % 2 == 0 and Enum.Material.Rock or Enum.Material.Ice
    detail.Parent = template
end

template.PrimaryPart = primaryPart

return template
