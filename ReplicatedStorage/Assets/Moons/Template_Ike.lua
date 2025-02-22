local PhysicsConstants = require(game.ReplicatedStorage.Modules.PhysicsConstants)

-- Ike Template - Rocky Moon of Duna
local template = Instance.new("Model")
template.Name = "Template_Ike"

-- Core sphere (main body)
local primaryPart = Instance.new("Part")
primaryPart.Name = "PrimaryPart"
primaryPart.Shape = Enum.PartType.Ball
primaryPart.Size = Vector3.new(
    PhysicsConstants.IKE.RADIUS * 2,
    PhysicsConstants.IKE.RADIUS * 2,
    PhysicsConstants.IKE.RADIUS * 2
)
primaryPart.Position = Vector3.new(0, 0, 0)
primaryPart.Anchored = true
primaryPart.BrickColor = BrickColor.new("Medium stone grey")
primaryPart.Material = Enum.Material.Rock
primaryPart.Parent = template

-- Add major craters
local craters = {
    {
        name = "Crater_Alpha",
        size = Vector3.new(40, 8, 40),
        position = Vector3.new(30, 20, 0),
        scale = Vector3.new(1, 0.2, 1)
    },
    {
        name = "Crater_Beta",
        size = Vector3.new(35, 7, 35),
        position = Vector3.new(-25, -15, 20),
        scale = Vector3.new(1, 0.18, 1)
    }
}

-- Create crater pieces
for _, crater in ipairs(craters) do
    local part = Instance.new("Part")
    part.Name = crater.name
    part.Size = crater.size
    part.Position = crater.position
    part.BrickColor = BrickColor.new("Dark stone grey")
    part.Material = Enum.Material.Slate
    -- Use mesh for crater shape
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.Cylinder
    mesh.Scale = crater.scale
    mesh.Parent = part
    part.Parent = template
end

-- Add surface features (ridges and hills)
local features = {
    {
        name = "Ridge_North",
        size = Vector3.new(50, 10, 20),
        position = Vector3.new(0, 40, 0),
        rotation = CFrame.Angles(0, math.rad(45), math.rad(15))
    },
    {
        name = "Hill_South",
        size = Vector3.new(30, 15, 30),
        position = Vector3.new(-20, -30, 10),
        rotation = CFrame.Angles(math.rad(20), 0, math.rad(-30))
    }
}

-- Create surface features
for _, feature in ipairs(features) do
    local part = Instance.new("Part")
    part.Name = feature.name
    part.Size = feature.size
    part.CFrame = CFrame.new(feature.position) * feature.rotation
    part.BrickColor = BrickColor.new("Medium stone grey")
    part.Material = Enum.Material.Rock
    part.Parent = template
end

-- Add scattered rocks
for i = 1, 6 do
    local rock = Instance.new("Part")
    rock.Name = "Rock_" .. i
    rock.Shape = Enum.PartType.Ball
    rock.Size = Vector3.new(4 + math.random(-1, 1), 3 + math.random(-1, 1), 4 + math.random(-1, 1))
    -- Distribute rocks evenly
    local angle = (i / 6) * math.pi * 2
    rock.Position = Vector3.new(
        math.cos(angle) * 20,
        math.sin(angle) * 20,
        math.random(-5, 5)
    )
    rock.BrickColor = BrickColor.new("Dark stone grey")
    rock.Material = Enum.Material.Rock
    rock.Parent = template
end

template.PrimaryPart = primaryPart

return template
