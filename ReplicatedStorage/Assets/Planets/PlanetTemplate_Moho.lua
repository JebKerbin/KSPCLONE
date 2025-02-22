local PhysicsConstants = require(game.ReplicatedStorage.Modules.PhysicsConstants)

-- Moho Template - Innermost Planet
local template = Instance.new("Model")
template.Name = "PlanetTemplate_Moho"

-- Core sphere (main body)
local primaryPart = Instance.new("Part")
primaryPart.Name = "PrimaryPart"
primaryPart.Shape = Enum.PartType.Ball
primaryPart.Size = Vector3.new(
    PhysicsConstants.MOHO.RADIUS * 2,
    PhysicsConstants.MOHO.RADIUS * 2,
    PhysicsConstants.MOHO.RADIUS * 2
)
primaryPart.Position = Vector3.new(0, 0, 0)
primaryPart.Anchored = true
primaryPart.BrickColor = BrickColor.new("Dark stone grey")
primaryPart.Material = Enum.Material.Rock
primaryPart.Parent = template

-- Add major impact basins
local basins = {
    {
        name = "Caloris_Basin",
        size = Vector3.new(100, 20, 100),
        position = Vector3.new(50, 30, 0),
        scale = Vector3.new(1, 0.15, 1)
    },
    {
        name = "Rembrandt_Basin",
        size = Vector3.new(80, 15, 80),
        position = Vector3.new(-40, -20, 30),
        scale = Vector3.new(1, 0.12, 1)
    },
    {
        name = "Rachmaninoff_Basin",
        size = Vector3.new(90, 18, 90),
        position = Vector3.new(10, 60, 20),
        scale = Vector3.new(1, 0.14, 1)
    }
}

-- Create impact basin pieces
for _, basin in ipairs(basins) do
    local part = Instance.new("Part")
    part.Name = basin.name
    part.Size = basin.size
    part.Position = basin.position
    part.BrickColor = BrickColor.new("Medium stone grey")
    part.Material = Enum.Material.Slate
    -- Use mesh for basin shape
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.Cylinder
    mesh.Scale = basin.scale
    mesh.Parent = part
    part.Parent = template
end

-- Add surface details (smaller craters and scarps)
for i = 1, 12 do
    local crater = Instance.new("Part")
    crater.Name = "Crater_" .. i
    crater.Shape = Enum.PartType.Cylinder
    crater.Size = Vector3.new(20 + math.random(-8, 8), 5, 20 + math.random(-8, 8))
    -- Distribute craters evenly
    local angle = (i / 12) * math.pi * 2
    local radius = math.random(40, 60)
    crater.Position = Vector3.new(
        math.cos(angle) * radius,
        math.sin(angle) * radius,
        math.random(-30, 30)
    )
    crater.BrickColor = BrickColor.new("Dark stone grey")
    crater.Material = Enum.Material.Rock
    crater.Parent = template
end

-- Add scarps (cliff-like features)
local scarps = {
    {
        name = "Discovery_Scarp",
        size = Vector3.new(60, 10, 8),
        position = Vector3.new(30, 40, 0),
        rotation = CFrame.Angles(0, math.rad(45), math.rad(15))
    },
    {
        name = "Enterprise_Scarp",
        size = Vector3.new(50, 8, 6),
        position = Vector3.new(-25, -30, 20),
        rotation = CFrame.Angles(math.rad(30), 0, math.rad(-20))
    }
}

-- Create scarp pieces
for _, scarp in ipairs(scarps) do
    local part = Instance.new("Part")
    part.Name = scarp.name
    part.Size = scarp.size
    part.CFrame = CFrame.new(scarp.position) * scarp.rotation
    part.BrickColor = BrickColor.new("Dark stone grey")
    part.Material = Enum.Material.Rock
    part.Parent = template
end

template.PrimaryPart = primaryPart

return template
