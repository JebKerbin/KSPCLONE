local PhysicsConstants = require(game.ReplicatedStorage.Modules.PhysicsConstants)

-- Laythe Template - Ocean Moon with Atmosphere
local template = Instance.new("Model")
template.Name = "PlanetTemplate_Laythe"

-- Create Pieces folder to hold the quarter-circle segments
local pieces = Instance.new("Folder")
pieces.Name = "Pieces"
pieces.Parent = template

-- Create the eight quarter-circle pieces
for i = 1, 8 do
    local piece = Instance.new("MeshPart")
    piece.Name = "Piece"
    piece.Size = Vector3.new(
        PhysicsConstants.LAYTHE.RADIUS * 0.5,
        PhysicsConstants.LAYTHE.RADIUS * 0.5,
        PhysicsConstants.LAYTHE.RADIUS * 0.5
    )
    -- Position and rotate pieces to form a sphere
    local angle = (i - 1) * math.pi / 4
    piece.CFrame = CFrame.new(0, 0, 0) *
        CFrame.fromEulerAnglesXYZ(0, angle, 0)
    piece.BrickColor = BrickColor.new("Deep blue")
    piece.Material = Enum.Material.Ice
    piece.Parent = pieces
end

-- Add ocean layer
local ocean = Instance.new("Part")
ocean.Name = "Ocean"
ocean.Shape = Enum.PartType.Ball
ocean.Size = Vector3.new(
    PhysicsConstants.LAYTHE.RADIUS * 2.01,
    PhysicsConstants.LAYTHE.RADIUS * 2.01,
    PhysicsConstants.LAYTHE.RADIUS * 2.01
)
ocean.Position = Vector3.new(0, 0, 0)
ocean.Transparency = 0.7
ocean.BrickColor = BrickColor.new("Bright blue")
ocean.Material = Enum.Material.Glass
ocean.CanCollide = false
ocean.Parent = template

-- Add cloud layers
local cloudLayers = {
    {height = 1.02, color = "White", transparency = 0.8},
    {height = 1.03, color = "Institutional white", transparency = 0.85},
    {height = 1.04, color = "Ghost grey", transparency = 0.9}
}

for i, layer in ipairs(cloudLayers) do
    local clouds = Instance.new("Part")
    clouds.Name = "CloudLayer_" .. i
    clouds.Shape = Enum.PartType.Ball
    local size = PhysicsConstants.LAYTHE.RADIUS * 2 * layer.height
    clouds.Size = Vector3.new(size, size, size)
    clouds.Position = Vector3.new(0, 0, 0)
    clouds.Transparency = layer.transparency
    clouds.BrickColor = BrickColor.new(layer.color)
    clouds.Material = Enum.Material.SmoothPlastic
    clouds.CanCollide = false

    -- Add cloud particles
    local particles = Instance.new("ParticleEmitter")
    particles.Rate = 50
    particles.Lifetime = NumberRange.new(2, 4)
    particles.Speed = NumberRange.new(1, 2)
    particles.Rotation = NumberRange.new(0, 360)
    particles.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 5),
        NumberSequenceKeypoint.new(1, 3)
    })
    particles.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.5),
        NumberSequenceKeypoint.new(1, 1)
    })
    particles.Parent = clouds
    clouds.Parent = template
end

-- Add atmosphere glow
local atmosphere = Instance.new("Part")
atmosphere.Name = "Atmosphere"
atmosphere.Shape = Enum.PartType.Ball
atmosphere.Size = Vector3.new(
    (PhysicsConstants.LAYTHE.RADIUS + PhysicsConstants.LAYTHE.ATMOSPHERE_HEIGHT) * 2,
    (PhysicsConstants.LAYTHE.RADIUS + PhysicsConstants.LAYTHE.ATMOSPHERE_HEIGHT) * 2,
    (PhysicsConstants.LAYTHE.RADIUS + PhysicsConstants.LAYTHE.ATMOSPHERE_HEIGHT) * 2
)
atmosphere.Position = Vector3.new(0, 0, 0)
atmosphere.Transparency = 0.95
atmosphere.BrickColor = BrickColor.new("Light blue")
atmosphere.Material = Enum.Material.Neon
atmosphere.CanCollide = false
atmosphere.Parent = template

template.PrimaryPart = pieces:FindFirstChild("Piece")

return template