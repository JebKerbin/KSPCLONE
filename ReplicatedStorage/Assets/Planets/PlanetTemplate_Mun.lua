local PhysicsConstants = require(game.ReplicatedStorage.Modules.PhysicsConstants)

-- Mun Template with crater details
local template = Instance.new("Model")
template.Name = "PlanetTemplate_Mun"

-- Core sphere (main body)
local primaryPart = Instance.new("Part")
primaryPart.Name = "PrimaryPart"
primaryPart.Shape = Enum.PartType.Ball
primaryPart.Size = Vector3.new(
    PhysicsConstants.MUN.RADIUS * 2,
    PhysicsConstants.MUN.RADIUS * 2,
    PhysicsConstants.MUN.RADIUS * 2
)
primaryPart.Position = Vector3.new(0, 0, 0)
primaryPart.Anchored = true
primaryPart.BrickColor = BrickColor.new("Fossil")
primaryPart.Material = Enum.Material.Rock
primaryPart.Parent = template

-- Add major craters
local craters = {
    {
        name = "EastCrater",
        size = Vector3.new(60, 15, 60),
        position = Vector3.new(45, 20, 0),
        scale = Vector3.new(1, 0.2, 1)
    },
    {
        name = "WestCrater",
        size = Vector3.new(40, 12, 40),
        position = Vector3.new(-40, -15, 10),
        scale = Vector3.new(1, 0.15, 1)
    },
    {
        name = "NorthCrater",
        size = Vector3.new(50, 10, 50),
        position = Vector3.new(0, 45, 0),
        scale = Vector3.new(1, 0.18, 1)
    }
}

-- Create crater pieces
for _, crater in ipairs(craters) do
    local part = Instance.new("Part")
    part.Name = crater.name
    part.Size = crater.size
    part.Position = crater.position
    part.BrickColor = BrickColor.new("Sand")
    part.Material = Enum.Material.Slate
    -- Use custom mesh for crater shape
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.Cylinder
    mesh.Scale = crater.scale
    mesh.Parent = part
    part.Parent = template
end

-- Add lunar maria (dark regions)
local maria = {
    {
        name = "Mare_Tranquillitatis",
        size = Vector3.new(80, 5, 70),
        position = Vector3.new(30, 10, 20),
        color = "Dark stone grey"
    },
    {
        name = "Mare_Serenitatis",
        size = Vector3.new(70, 5, 60),
        position = Vector3.new(-20, -25, -10),
        color = "Dark stone grey"
    }
}

-- Create maria pieces
for _, mare in ipairs(maria) do
    local part = Instance.new("Part")
    part.Name = mare.name
    part.Size = mare.size
    part.Position = mare.position
    part.BrickColor = BrickColor.new(mare.color)
    part.Material = Enum.Material.Slate
    -- Use mesh to curve the maria
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.Scale = Vector3.new(1, 0.1, 1)
    mesh.Parent = part
    part.Parent = template
end

-- Add surface details (small craters and rocks)
for i = 1, 10 do
    local detail = Instance.new("Part")
    detail.Name = "SurfaceDetail_" .. i
    detail.Shape = Enum.PartType.Ball
    detail.Size = Vector3.new(10, 5, 10)
    -- Distribute details around the surface
    local angle = (i / 10) * math.pi * 2
    detail.Position = Vector3.new(
        math.cos(angle) * 40,
        math.sin(angle) * 40,
        0
    )
    detail.BrickColor = BrickColor.new("Fossil")
    detail.Material = Enum.Material.Rock
    detail.Parent = template
end

template.PrimaryPart = primaryPart

return template