local PhysicsConstants = require(game.ReplicatedStorage.Modules.PhysicsConstants)

-- Minmus Template - Small Ice Moon
local template = Instance.new("Model")
template.Name = "PlanetTemplate_Minmus"

-- Core sphere (main body)
local primaryPart = Instance.new("Part")
primaryPart.Name = "PrimaryPart"
primaryPart.Shape = Enum.PartType.Ball
primaryPart.Size = Vector3.new(
    PhysicsConstants.MINMUS.RADIUS * 2,
    PhysicsConstants.MINMUS.RADIUS * 2,
    PhysicsConstants.MINMUS.RADIUS * 2
)
primaryPart.Position = Vector3.new(0, 0, 0)
primaryPart.Anchored = true
primaryPart.BrickColor = BrickColor.new("Cyan")
primaryPart.Material = Enum.Material.Ice
primaryPart.Parent = template

-- Add ice flats
local iceFlats = {
    {
        name = "IceFlat_Alpha",
        size = Vector3.new(20, 3, 20),
        position = Vector3.new(10, 5, 0),
        scale = Vector3.new(1, 0.1, 1)
    },
    {
        name = "IceFlat_Beta",
        size = Vector3.new(15, 2, 15),
        position = Vector3.new(-8, -4, 5),
        scale = Vector3.new(1, 0.1, 1)
    }
}

-- Create ice flat pieces
for _, flat in ipairs(iceFlats) do
    local part = Instance.new("Part")
    part.Name = flat.name
    part.Size = flat.size
    part.Position = flat.position
    part.BrickColor = BrickColor.new("White")
    part.Material = Enum.Material.Ice
    -- Use mesh for ice flat shape
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.Scale = flat.scale
    mesh.Parent = part
    part.Parent = template
end

-- Add surface features
local features = {
    {
        name = "Peak_North",
        size = Vector3.new(10, 8, 10),
        position = Vector3.new(0, 15, 0),
        rotation = CFrame.Angles(0, 0, math.rad(30))
    },
    {
        name = "Valley_South",
        size = Vector3.new(12, 5, 8),
        position = Vector3.new(5, -12, 3),
        rotation = CFrame.Angles(math.rad(15), 0, math.rad(-20))
    }
}

-- Create surface features
for _, feature in ipairs(features) do
    local part = Instance.new("Part")
    part.Name = feature.name
    part.Size = feature.size
    part.CFrame = CFrame.new(feature.position) * feature.rotation
    part.BrickColor = BrickColor.new("Light blue")
    part.Material = Enum.Material.Ice
    part.Parent = template
end

template.PrimaryPart = primaryPart

return template