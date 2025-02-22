local PhysicsConstants = require(game.ReplicatedStorage.Modules.PhysicsConstants)

-- Ovin Template - Gas Giant with Dense Rings
local template = Instance.new("Model")
template.Name = "PlanetTemplate_Ovin"

-- Core body using eight quarter-circle MeshParts
local mainBody = Instance.new("Model")
mainBody.Name = "MainBody"
mainBody.Parent = template

-- Create the eight quarter-circle segments
for i = 1, 8 do
    local segment = Instance.new("Part")
    segment.Name = "Segment_" .. i
    segment.Size = Vector3.new(
        PhysicsConstants.OVIN.RADIUS * 0.5,
        PhysicsConstants.OVIN.RADIUS * 0.5,
        PhysicsConstants.OVIN.RADIUS * 0.5
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

    segment.BrickColor = BrickColor.new("Navy blue")
    segment.Material = Enum.Material.SmoothPlastic
    mesh.Parent = segment
    segment.Parent = mainBody
end

-- Add bright, dense ring system
local ringSystem = Instance.new("Model")
ringSystem.Name = "RingSystem"

-- Create multiple ring layers with varying characteristics
local ringLayers = {
    {radius = 1.6, color = "Really blue", transparency = 0.2},
    {radius = 1.8, color = "Deep blue", transparency = 0.3},
    {radius = 2.0, color = "Navy blue", transparency = 0.4},
    {radius = 2.2, color = "Bright blue", transparency = 0.5}
}

for i, layer in ipairs(ringLayers) do
    local ring = Instance.new("Part")
    ring.Name = "Ring_" .. i
    local radius = PhysicsConstants.OVIN.RADIUS * layer.radius
    ring.Size = Vector3.new(radius * 2, 1, radius * 2)
    ring.Position = Vector3.new(0, 0, 0)
    ring.Transparency = layer.transparency
    ring.BrickColor = BrickColor.new(layer.color)
    ring.Material = Enum.Material.Neon
    ring.CanCollide = false

    -- Create ring mesh
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.Cylinder
    mesh.Scale = Vector3.new(1, 0.02, 1) -- Thin but visible cylinder
    mesh.Parent = ring

    -- Add glowing effect
    local glow = Instance.new("PointLight")
    glow.Color = ring.BrickColor.Color
    glow.Range = radius * 0.5
    glow.Brightness = 0.5
    glow.Parent = ring

    ring.Parent = ringSystem
end

ringSystem.Parent = template

-- Add atmospheric bands
local bands = {
    {color = "Navy blue", yOffset = 200, scale = 1.02},
    {color = "Deep blue", yOffset = 100, scale = 1.01},
    {color = "Bright blue", yOffset = 0, scale = 1.00},
    {color = "Dark blue", yOffset = -100, scale = 1.01},
    {color = "Navy blue", yOffset = -200, scale = 1.02}
}

-- Create atmospheric bands
for _, band in ipairs(bands) do
    local part = Instance.new("Part")
    part.Name = "Band_" .. band.color
    part.Shape = Enum.PartType.Cylinder
    part.Size = Vector3.new(
        PhysicsConstants.OVIN.RADIUS * 2 * band.scale,
        50,
        PhysicsConstants.OVIN.RADIUS * 2 * band.scale
    )
    part.Position = Vector3.new(0, band.yOffset, 0)
    part.Transparency = 0.7
    part.BrickColor = BrickColor.new(band.color)
    part.Material = Enum.Material.SmoothPlastic
    part.CanCollide = false
    part.Parent = template
end

-- Add atmospheric glow
local atmosphere = Instance.new("Part")
atmosphere.Name = "Atmosphere"
atmosphere.Shape = Enum.PartType.Ball
atmosphere.Size = Vector3.new(
    (PhysicsConstants.OVIN.RADIUS + PhysicsConstants.OVIN.ATMOSPHERE_HEIGHT) * 2,
    (PhysicsConstants.OVIN.RADIUS + PhysicsConstants.OVIN.ATMOSPHERE_HEIGHT) * 2,
    (PhysicsConstants.OVIN.RADIUS + PhysicsConstants.OVIN.ATMOSPHERE_HEIGHT) * 2
)
atmosphere.Position = Vector3.new(0, 0, 0)
atmosphere.BrickColor = BrickColor.new("Cyan")
atmosphere.Material = Enum.Material.Neon
atmosphere.Transparency = 0.9
atmosphere.CanCollide = false
atmosphere.Parent = template

template.PrimaryPart = mainBody:FindFirstChild("Segment_1")

return template