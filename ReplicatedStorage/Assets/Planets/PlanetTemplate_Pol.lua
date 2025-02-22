local PhysicsConstants = require(game.ReplicatedStorage.Modules.PhysicsConstants)

-- Pol Template - Tiny Irregular Moon
local template = Instance.new("Model")
template.Name = "PlanetTemplate_Pol"

-- Core sphere (main body)
local primaryPart = Instance.new("Part")
primaryPart.Name = "PrimaryPart"
primaryPart.Shape = Enum.PartType.Ball
primaryPart.Size = Vector3.new(
    PhysicsConstants.POL.RADIUS * 2,
    PhysicsConstants.POL.RADIUS * 2,
    PhysicsConstants.POL.RADIUS * 2
)
primaryPart.Position = Vector3.new(0, 0, 0)
primaryPart.Anchored = true
primaryPart.BrickColor = BrickColor.new("Sand")
primaryPart.Material = Enum.Material.Rock
primaryPart.Parent = template

-- Add irregular surface features
local surfaceFeatures = {
    {
        name = "Peak_Alpha",
        size = Vector3.new(15, 6, 12),
        position = Vector3.new(10, 8, 0),
        rotation = CFrame.Angles(0, math.rad(30), math.rad(20))
    },
    {
        name = "Valley_Beta",
        size = Vector3.new(18, 4, 10),
        position = Vector3.new(-8, -6, 4),
        rotation = CFrame.Angles(math.rad(15), 0, math.rad(-25))
    }
}

-- Create surface features
for _, feature in ipairs(surfaceFeatures) do
    local part = Instance.new("Part")
    part.Name = feature.name
    part.Size = feature.size
    part.CFrame = CFrame.new(feature.position) * feature.rotation
    part.BrickColor = BrickColor.new("Brick yellow")
    part.Material = Enum.Material.Rock
    part.Parent = template
end

-- Add small craters
local craters = {
    {
        name = "Crater_Primary",
        size = Vector3.new(12, 4, 12),
        position = Vector3.new(0, 10, 0),
        scale = Vector3.new(1, 0.15, 1)
    },
    {
        name = "Crater_Minor",
        size = Vector3.new(8, 3, 8),
        position = Vector3.new(-6, -8, 5),
        scale = Vector3.new(1, 0.12, 1)
    }
}

-- Create crater pieces
for _, crater in ipairs(craters) do
    local part = Instance.new("Part")
    part.Name = crater.name
    part.Size = crater.size
    part.Position = crater.position
    part.BrickColor = BrickColor.new("Wheat")
    part.Material = Enum.Material.Slate
    -- Use mesh for crater shape
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.Cylinder
    mesh.Scale = crater.scale
    mesh.Parent = part
    part.Parent = template
end

-- Add scattered rocks
for i = 1, 5 do
    local rock = Instance.new("Part")
    rock.Name = "Rock_" .. i
    rock.Shape = Enum.PartType.Ball
    rock.Size = Vector3.new(3 + math.random(-1, 1), 2 + math.random(-1, 1), 3 + math.random(-1, 1))
    -- Distribute rocks evenly
    local angle = (i / 5) * math.pi * 2
    rock.Position = Vector3.new(
        math.cos(angle) * 10,
        math.sin(angle) * 10,
        math.random(-3, 3)
    )
    rock.BrickColor = BrickColor.new("Sand")
    rock.Material = Enum.Material.Rock
    rock.Parent = template
end

template.PrimaryPart = primaryPart

return template
