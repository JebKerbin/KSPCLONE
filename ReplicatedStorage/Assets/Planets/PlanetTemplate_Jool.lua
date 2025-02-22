local PhysicsConstants = require(game.ReplicatedStorage.Modules.PhysicsConstants)

-- Jool Template - Gas Giant
local template = Instance.new("Model")
template.Name = "PlanetTemplate_Jool"

-- Core sphere (main body - semi-transparent)
local primaryPart = Instance.new("Part")
primaryPart.Name = "PrimaryPart"
primaryPart.Shape = Enum.PartType.Ball
primaryPart.Size = Vector3.new(
    PhysicsConstants.JOOL.RADIUS * 2,
    PhysicsConstants.JOOL.RADIUS * 2,
    PhysicsConstants.JOOL.RADIUS * 2
)
primaryPart.Position = Vector3.new(0, 0, 0)
primaryPart.Anchored = true
primaryPart.BrickColor = BrickColor.new("Forest green")
primaryPart.Material = Enum.Material.Neon
primaryPart.Transparency = 0.3
primaryPart.Parent = template

-- Add atmospheric bands
local bands = {
    {
        name = "EquatorialBand",
        size = Vector3.new(1200, 100, 1200),
        position = Vector3.new(0, 0, 0),
        color = "Dark green",
        transparency = 0.5
    },
    {
        name = "NorthernBand",
        size = Vector3.new(1150, 80, 1150),
        position = Vector3.new(0, 200, 0),
        color = "Lime green",
        transparency = 0.6
    },
    {
        name = "SouthernBand",
        size = Vector3.new(1150, 80, 1150),
        position = Vector3.new(0, -200, 0),
        color = "Earth green",
        transparency = 0.6
    }
}

-- Create atmospheric bands
for _, band in ipairs(bands) do
    local part = Instance.new("Part")
    part.Name = band.name
    part.Size = band.size
    part.Position = band.position
    part.BrickColor = BrickColor.new(band.color)
    part.Material = Enum.Material.Neon
    part.Transparency = band.transparency
    -- Use mesh to create band effect
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.Cylinder
    mesh.Scale = Vector3.new(1, 0.1, 1)
    mesh.Parent = part
    part.Parent = template
end

-- Add thick atmosphere layers
for i = 1, 5 do
    local atmosphere = Instance.new("Part")
    atmosphere.Name = "AtmosphereLayer" .. i
    atmosphere.Shape = Enum.PartType.Ball
    atmosphere.Size = Vector3.new(
        PhysicsConstants.JOOL.RADIUS * 2 + (PhysicsConstants.JOOL.ATMOSPHERE_HEIGHT * i/3),
        PhysicsConstants.JOOL.RADIUS * 2 + (PhysicsConstants.JOOL.ATMOSPHERE_HEIGHT * i/3),
        PhysicsConstants.JOOL.RADIUS * 2 + (PhysicsConstants.JOOL.ATMOSPHERE_HEIGHT * i/3)
    )
    atmosphere.Position = Vector3.new(0, 0, 0)
    atmosphere.Transparency = 0.8 + (i * 0.03)
    atmosphere.BrickColor = BrickColor.new("Lime green")
    atmosphere.Material = Enum.Material.ForceField
    atmosphere.CanCollide = false
    atmosphere.Parent = template
end

-- Add swirling storm (Great Green Spot)
local storm = Instance.new("Part")
storm.Name = "GreatGreenSpot"
storm.Shape = Enum.PartType.Ball
storm.Size = Vector3.new(200, 50, 200)
storm.Position = Vector3.new(250, -100, 0)
storm.BrickColor = BrickColor.new("Bright green")
storm.Material = Enum.Material.Neon
storm.Transparency = 0.4
local mesh = Instance.new("SpecialMesh")
mesh.MeshType = Enum.MeshType.FileMesh
mesh.Scale = Vector3.new(1, 0.2, 1)
mesh.Parent = storm
storm.Parent = template

template.PrimaryPart = primaryPart

return template
