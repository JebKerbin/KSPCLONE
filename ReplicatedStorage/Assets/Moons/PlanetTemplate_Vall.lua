local PhysicsConstants = require(game.ReplicatedStorage.Modules.PhysicsConstants)

-- Vall Template - Icy Moon
local template = Instance.new("Model")
template.Name = "PlanetTemplate_Vall"

-- Core sphere (main body)
local primaryPart = Instance.new("Part")
primaryPart.Name = "PrimaryPart"
primaryPart.Shape = Enum.PartType.Ball
primaryPart.Size = Vector3.new(
    PhysicsConstants.VALL.RADIUS * 2,
    PhysicsConstants.VALL.RADIUS * 2,
    PhysicsConstants.VALL.RADIUS * 2
)
primaryPart.Position = Vector3.new(0, 0, 0)
primaryPart.Anchored = true
primaryPart.BrickColor = BrickColor.new("Institutional white")
primaryPart.Material = Enum.Material.Ice
primaryPart.Parent = template

-- Add major craters
local craters = {
    {
        name = "Crater_Alpha",
        size = Vector3.new(70, 15, 70),
        position = Vector3.new(50, 30, 0),
        scale = Vector3.new(1, 0.15, 1)
    },
    {
        name = "Crater_Beta",
        size = Vector3.new(50, 12, 50),
        position = Vector3.new(-40, -20, 30),
        scale = Vector3.new(1, 0.12, 1)
    },
    {
        name = "Crater_Gamma",
        size = Vector3.new(60, 10, 60),
        position = Vector3.new(10, 60, 20),
        scale = Vector3.new(1, 0.1, 1)
    }
}

-- Create crater pieces
for _, crater in ipairs(craters) do
    local part = Instance.new("Part")
    part.Name = crater.name
    part.Size = crater.size
    part.Position = crater.position
    part.BrickColor = BrickColor.new("Ghost grey")
    part.Material = Enum.Material.Ice
    -- Use mesh for crater shape
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.Cylinder
    mesh.Scale = crater.scale
    mesh.Parent = part
    part.Parent = template
end

-- Add ice ridges
local ridges = {
    {
        name = "Ridge_North",
        size = Vector3.new(100, 8, 30),
        position = Vector3.new(0, 70, 0),
        rotation = CFrame.Angles(0, 0, math.rad(45))
    },
    {
        name = "Ridge_South",
        size = Vector3.new(80, 6, 25),
        position = Vector3.new(20, -60, 10),
        rotation = CFrame.Angles(0, math.rad(30), 0)
    }
}

-- Create ridge pieces
for _, ridge in ipairs(ridges) do
    local part = Instance.new("Part")
    part.Name = ridge.name
    part.Size = ridge.size
    part.CFrame = CFrame.new(ridge.position) * ridge.rotation
    part.BrickColor = BrickColor.new("White")
    part.Material = Enum.Material.Ice
    part.Parent = template
end

-- Add surface texture details
for i = 1, 8 do
    local detail = Instance.new("Part")
    detail.Name = "IceDetail_" .. i
    detail.Size = Vector3.new(20, 4, 20)
    -- Distribute details evenly
    local angle = (i / 8) * math.pi * 2
    detail.Position = Vector3.new(
        math.cos(angle) * 50,
        math.sin(angle) * 50,
        0
    )
    detail.BrickColor = BrickColor.new("Institutional white")
    detail.Material = Enum.Material.Ice
    detail.Parent = template
end

template.PrimaryPart = primaryPart

return template