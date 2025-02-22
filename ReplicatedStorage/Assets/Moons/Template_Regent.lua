local PhysicsConstants = require(game.ReplicatedStorage.Modules.PhysicsConstants)

-- Regent Template - Moon of Ovin with high inclination
local template = Instance.new("Model")
template.Name = "Template_Regent"

-- Core sphere (main body)
local primaryPart = Instance.new("Part")
primaryPart.Name = "PrimaryPart"
primaryPart.Shape = Enum.PartType.Ball
primaryPart.Size = Vector3.new(
    PhysicsConstants.REGENT.RADIUS * 2,
    PhysicsConstants.REGENT.RADIUS * 2,
    PhysicsConstants.REGENT.RADIUS * 2
)
primaryPart.Position = Vector3.new(0, 0, 0)
primaryPart.Anchored = true
primaryPart.BrickColor = BrickColor.new("Dark stone grey")
primaryPart.Material = Enum.Material.Rock
primaryPart.Parent = template

-- Add crater features
local craters = {
    {
        name = "Crater_Major",
        size = Vector3.new(45, 10, 45),
        position = Vector3.new(35, 15, 0),
        scale = Vector3.new(1, 0.2, 1)
    },
    {
        name = "Crater_Minor",
        size = Vector3.new(30, 8, 30),
        position = Vector3.new(-25, -20, 15),
        scale = Vector3.new(1, 0.15, 1)
    }
}

-- Create crater pieces
for _, crater in ipairs(craters) do
    local part = Instance.new("Part")
    part.Name = crater.name
    part.Size = crater.size
    part.Position = crater.position
    part.BrickColor = BrickColor.new("Really black")
    part.Material = Enum.Material.Slate
    -- Use mesh for crater shape
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.Cylinder
    mesh.Scale = crater.scale
    mesh.Parent = part
    part.Parent = template
end

-- Add ridges and valleys
local features = {
    {
        name = "Ridge_East",
        size = Vector3.new(60, 12, 25),
        position = Vector3.new(30, 0, 0),
        rotation = CFrame.Angles(0, 0, math.rad(30))
    },
    {
        name = "Valley_West",
        size = Vector3.new(50, 15, 20),
        position = Vector3.new(-25, 10, 0),
        rotation = CFrame.Angles(0, 0, math.rad(-25))
    }
}

-- Create surface features
for _, feature in ipairs(features) do
    local part = Instance.new("Part")
    part.Name = feature.name
    part.Size = feature.size
    part.CFrame = CFrame.new(feature.position) * feature.rotation
    part.BrickColor = BrickColor.new("Dark stone grey")
    part.Material = Enum.Material.Rock
    part.Parent = template
end

-- Add scattered boulders
for i = 1, 5 do
    local boulder = Instance.new("Part")
    boulder.Name = "Boulder_" .. i
    boulder.Shape = Enum.PartType.Ball
    boulder.Size = Vector3.new(5 + math.random(-2, 2), 4 + math.random(-1, 1), 5 + math.random(-2, 2))
    -- Distribute boulders evenly
    local angle = (i / 5) * math.pi * 2
    boulder.Position = Vector3.new(
        math.cos(angle) * 25,
        math.sin(angle) * 25,
        math.random(-10, 10)
    )
    boulder.BrickColor = BrickColor.new("Really black")
    boulder.Material = Enum.Material.Rock
    boulder.Parent = template
end

template.PrimaryPart = primaryPart

return template
