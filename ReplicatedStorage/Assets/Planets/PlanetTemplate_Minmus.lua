local PhysicsConstants = require(game.ReplicatedStorage.Modules.PhysicsConstants)

-- Minmus Template
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

-- Add ice flats (characteristic feature of Minmus)
local iceFlats = {
    {
        name = "IceFlat_North",
        size = Vector3.new(25, 2, 25),
        position = Vector3.new(0, 12, 0),
        scale = Vector3.new(1, 0.1, 1)
    },
    {
        name = "IceFlat_South",
        size = Vector3.new(20, 2, 20),
        position = Vector3.new(0, -10, 0),
        scale = Vector3.new(1, 0.1, 1)
    }
}

-- Create ice flat pieces
for _, flat in ipairs(iceFlats) do
    local part = Instance.new("Part")
    part.Name = flat.name
    part.Size = flat.size
    part.Position = flat.position
    part.BrickColor = BrickColor.new("Light blue")
    part.Material = Enum.Material.Ice
    -- Use mesh for smooth ice flats
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.Scale = flat.scale
    mesh.Parent = part
    part.Parent = template
end

template.PrimaryPart = primaryPart

return template