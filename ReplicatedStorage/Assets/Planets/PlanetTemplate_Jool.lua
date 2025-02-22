local PhysicsConstants = require(game.ReplicatedStorage.Modules.PhysicsConstants)

-- Jool Template - Gas Giant with Faint Rings
local template = Instance.new("Model")
template.Name = "PlanetTemplate_Jool"

-- Core sphere (main body) using eight quarter-circle MeshParts
local mainBody = Instance.new("Model")
mainBody.Name = "MainBody"
mainBody.Parent = template

-- Create the eight quarter-circle segments
for i = 1, 8 do
    local segment = Instance.new("Part")
    segment.Name = "Segment_" .. i
    segment.Size = Vector3.new(
        PhysicsConstants.JOOL.RADIUS * 0.5,
        PhysicsConstants.JOOL.RADIUS * 0.5,
        PhysicsConstants.JOOL.RADIUS * 0.5
    )

    -- Create quarter-sphere mesh
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.MeshId = "rbxasset://meshes/quarterspheresegment.mesh"
    mesh.Scale = Vector3.new(1, 1, 1)

    -- Position and rotate segments to form a sphere
    local angle = (i - 1) * math.pi / 4
    segment.CFrame = CFrame.new(0, 0, 0) *
        CFrame.fromEulerAnglesXYZ(0, angle, 0)

    segment.BrickColor = BrickColor.new("Forest green")
    segment.Material = Enum.Material.SmoothPlastic
    segment.Transparency = 0.1
    mesh.Parent = segment
    segment.Parent = mainBody
end

-- Add faint ring system
local ringSystem = Instance.new("Model")
ringSystem.Name = "RingSystem"

-- Create multiple ring layers with varying characteristics
local ringLayers = {
    {radius = 1.8, color = "Forest green", transparency = 0.7},
    {radius = 2.0, color = "Lime green", transparency = 0.8},
    {radius = 2.2, color = "Earth green", transparency = 0.85}
}

for i, layer in ipairs(ringLayers) do
    local ring = Instance.new("Part")
    ring.Name = "Ring_" .. i
    local radius = PhysicsConstants.JOOL.RADIUS * layer.radius
    ring.Size = Vector3.new(radius * 2, 1, radius * 2)
    ring.Position = Vector3.new(0, 0, 0)
    ring.Transparency = layer.transparency
    ring.BrickColor = BrickColor.new(layer.color)
    ring.Material = Enum.Material.Neon
    ring.CanCollide = false

    -- Create ring mesh
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.Cylinder
    mesh.Scale = Vector3.new(1, 0.01, 1) -- Very thin cylinder
    mesh.Parent = ring

    -- Add subtle glow
    local glow = Instance.new("PointLight")
    glow.Color = ring.BrickColor.Color
    glow.Range = radius * 0.3
    glow.Brightness = 0.2
    glow.Parent = ring

    ring.Parent = ringSystem
end

ringSystem.Parent = template

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
    part.CanCollide = false

    -- Create band mesh
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

-- Add the iconic Great Green Spot
local storm = Instance.new("Part")
storm.Name = "GreatGreenSpot"
storm.Shape = Enum.PartType.Ball
storm.Size = Vector3.new(200, 50, 200)
storm.Position = Vector3.new(250, -100, 0)
storm.BrickColor = BrickColor.new("Bright green")
storm.Material = Enum.Material.Neon
storm.Transparency = 0.4

-- Add swirl effect to the storm
local swirl = Instance.new("ParticleEmitter")
swirl.Rate = 20
swirl.Lifetime = NumberRange.new(2, 4)
swirl.Speed = NumberRange.new(5, 10)
swirl.Rotation = NumberRange.new(0, 360)
swirl.SpreadAngle = Vector2.new(45, 45)
swirl.Size = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 10),
    NumberSequenceKeypoint.new(1, 5)
})
swirl.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.4),
    NumberSequenceKeypoint.new(1, 1)
})
swirl.Parent = storm

storm.Parent = template

template.PrimaryPart = mainBody:FindFirstChild("Segment_1")

return template