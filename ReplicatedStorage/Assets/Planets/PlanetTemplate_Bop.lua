local PhysicsConstants = require(game.ReplicatedStorage.Modules.PhysicsConstants)

-- Bop Template - Small Irregular Moon
local template = Instance.new("Model")
template.Name = "PlanetTemplate_Bop"

-- Core sphere (main body)
local primaryPart = Instance.new("Part")
primaryPart.Name = "PrimaryPart"
primaryPart.Shape = Enum.PartType.Ball
primaryPart.Size = Vector3.new(
    PhysicsConstants.BOP.RADIUS * 2,
    PhysicsConstants.BOP.RADIUS * 2,
    PhysicsConstants.BOP.RADIUS * 2
)
primaryPart.Position = Vector3.new(0, 0, 0)
primaryPart.Anchored = true
primaryPart.BrickColor = BrickColor.new("Dark stone grey")
primaryPart.Material = Enum.Material.Rock
primaryPart.Parent = template

-- Add irregular terrain features
local terrainFeatures = {
    {
        name = "Ridge_Alpha",
        size = Vector3.new(25, 8, 15),
        position = Vector3.new(15, 10, 0),
        rotation = CFrame.Angles(0, math.rad(45), math.rad(15))
    },
    {
        name = "Ridge_Beta",
        size = Vector3.new(20, 6, 12),
        position = Vector3.new(-12, -8, 5),
        rotation = CFrame.Angles(math.rad(30), 0, math.rad(-20))
    }
}

-- Create terrain pieces
for _, feature in ipairs(terrainFeatures) do
    local part = Instance.new("Part")
    part.Name = feature.name
    part.Size = feature.size
    part.CFrame = CFrame.new(feature.position) * feature.rotation
    part.BrickColor = BrickColor.new("Really black")
    part.Material = Enum.Material.Rock
    part.Parent = template
end

-- Add impact craters
local craters = {
    {
        name = "Crater_Main",
        size = Vector3.new(20, 5, 20),
        position = Vector3.new(0, 15, 0),
        scale = Vector3.new(1, 0.2, 1)
    },
    {
        name = "Crater_Secondary",
        size = Vector3.new(15, 4, 15),
        position = Vector3.new(-10, -12, 8),
        scale = Vector3.new(1, 0.15, 1)
    }
}

-- Create crater pieces
for _, crater in ipairs(craters) do
    local part = Instance.new("Part")
    part.Name = crater.name
    part.Size = crater.size
    part.Position = crater.position
    part.BrickColor = BrickColor.new("Black")
    part.Material = Enum.Material.Slate
    -- Use mesh for crater shape
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.Cylinder
    mesh.Scale = crater.scale
    mesh.Parent = part
    part.Parent = template
end

-- Add surface details (boulders and rocks)
for i = 1, 6 do
    local boulder = Instance.new("Part")
    boulder.Name = "Boulder_" .. i
    boulder.Shape = Enum.PartType.Ball
    boulder.Size = Vector3.new(5 + math.random(-2, 2), 4 + math.random(-1, 1), 5 + math.random(-2, 2))
    -- Distribute boulders around the surface
    local angle = (i / 6) * math.pi * 2
    boulder.Position = Vector3.new(
        math.cos(angle) * 15,
        math.sin(angle) * 15,
        math.random(-5, 5)
    )
    boulder.BrickColor = BrickColor.new("Dark stone grey")
    boulder.Material = Enum.Material.Rock
    boulder.Parent = template
end

template.PrimaryPart = primaryPart

return template
