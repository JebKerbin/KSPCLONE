local PhysicsConstants = require(game.ReplicatedStorage.Modules.PhysicsConstants)

-- Mayor Template - Moon of Ovin
local template = Instance.new("Model")
template.Name = "Template_Mayor"

-- Core sphere (main body)
local primaryPart = Instance.new("Part")
primaryPart.Name = "PrimaryPart"
primaryPart.Shape = Enum.PartType.Ball
primaryPart.Size = Vector3.new(
    PhysicsConstants.MAYOR.RADIUS * 2,
    PhysicsConstants.MAYOR.RADIUS * 2,
    PhysicsConstants.MAYOR.RADIUS * 2
)
primaryPart.Position = Vector3.new(0, 0, 0)
primaryPart.Anchored = true
primaryPart.BrickColor = BrickColor.new("Medium stone grey")
primaryPart.Material = Enum.Material.Rock
primaryPart.Parent = template

-- Add major impact basins
local basins = {
    {
        name = "Basin_Alpha",
        size = Vector3.new(60, 12, 60),
        position = Vector3.new(40, 20, 0),
        scale = Vector3.new(1, 0.15, 1)
    },
    {
        name = "Basin_Beta",
        size = Vector3.new(50, 10, 50),
        position = Vector3.new(-30, -15, 25),
        scale = Vector3.new(1, 0.12, 1)
    }
}

-- Create basin pieces
for _, basin in ipairs(basins) do
    local part = Instance.new("Part")
    part.Name = basin.name
    part.Size = basin.size
    part.Position = basin.position
    part.BrickColor = BrickColor.new("Dark stone grey")
    part.Material = Enum.Material.Slate
    -- Use mesh for basin shape
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.Cylinder
    mesh.Scale = basin.scale
    mesh.Parent = part
    part.Parent = template
end

-- Add mountain ranges
local mountains = {
    {
        name = "Range_North",
        size = Vector3.new(70, 20, 30),
        position = Vector3.new(0, 50, 0),
        rotation = CFrame.Angles(0, math.rad(45), math.rad(15))
    },
    {
        name = "Range_South",
        size = Vector3.new(60, 15, 25),
        position = Vector3.new(-20, -40, 10),
        rotation = CFrame.Angles(math.rad(20), 0, math.rad(-30))
    }
}

-- Create mountain ranges
for _, mountain in ipairs(mountains) do
    local part = Instance.new("Part")
    part.Name = mountain.name
    part.Size = mountain.size
    part.CFrame = CFrame.new(mountain.position) * mountain.rotation
    part.BrickColor = BrickColor.new("Medium stone grey")
    part.Material = Enum.Material.Rock
    part.Parent = template
end

template.PrimaryPart = primaryPart

return template
