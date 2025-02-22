local PhysicsConstants = require(game.ReplicatedStorage.Modules.PhysicsConstants)

-- Gilly Template - Tiny Irregular Moon of Eve
local template = Instance.new("Model")
template.Name = "PlanetTemplate_Gilly"

-- Core part (irregular shape)
local primaryPart = Instance.new("Part")
primaryPart.Name = "PrimaryPart"
primaryPart.Shape = Enum.PartType.Ball
primaryPart.Size = Vector3.new(
    PhysicsConstants.GILLY.RADIUS * 2,
    PhysicsConstants.GILLY.RADIUS * 2,
    PhysicsConstants.GILLY.RADIUS * 2
)
primaryPart.Position = Vector3.new(0, 0, 0)
primaryPart.Anchored = true
primaryPart.BrickColor = BrickColor.new("Brown")
primaryPart.Material = Enum.Material.Rock
primaryPart.Parent = template

-- Add irregular surface features
local features = {
    {
        name = "Peak_Alpha",
        size = Vector3.new(8, 4, 6),
        position = Vector3.new(5, 3, 0),
        rotation = CFrame.Angles(0, math.rad(30), math.rad(20))
    },
    {
        name = "Ridge_Beta",
        size = Vector3.new(7, 3, 4),
        position = Vector3.new(-3, -2, 2),
        rotation = CFrame.Angles(math.rad(15), 0, math.rad(-25))
    }
}

for _, feature in ipairs(features) do
    local part = Instance.new("Part")
    part.Name = feature.name
    part.Size = feature.size
    part.CFrame = CFrame.new(feature.position) * feature.rotation
    part.BrickColor = BrickColor.new("Reddish brown")
    part.Material = Enum.Material.Rock
    part.Parent = template
end

-- Add small craters
local craters = {
    {
        name = "Crater_A",
        size = Vector3.new(6, 2, 6),
        position = Vector3.new(0, 4, 0),
        scale = Vector3.new(1, 0.2, 1)
    },
    {
        name = "Crater_B",
        size = Vector3.new(4, 1.5, 4),
        position = Vector3.new(-2, -3, 2),
        scale = Vector3.new(1, 0.15, 1)
    }
}

for _, crater in ipairs(craters) do
    local part = Instance.new("Part")
    part.Name = crater.name
    part.Size = crater.size
    part.Position = crater.position
    part.BrickColor = BrickColor.new("Dark taupe")
    part.Material = Enum.Material.Slate
    -- Use mesh for crater shape
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.Cylinder
    mesh.Scale = crater.scale
    mesh.Parent = part
    part.Parent = template
end

-- Add scattered rocks
for i = 1, 4 do
    local rock = Instance.new("Part")
    rock.Name = "Rock_" .. i
    rock.Shape = Enum.PartType.Ball
    rock.Size = Vector3.new(2 + math.random(-1, 1), 1.5 + math.random(-0.5, 0.5), 2 + math.random(-1, 1))
    -- Distribute rocks evenly
    local angle = (i / 4) * math.pi * 2
    rock.Position = Vector3.new(
        math.cos(angle) * 3,
        math.sin(angle) * 3,
        math.random(-1, 1)
    )
    rock.BrickColor = BrickColor.new("Brown")
    rock.Material = Enum.Material.Rock
    rock.Parent = template
end

template.PrimaryPart = primaryPart

return template