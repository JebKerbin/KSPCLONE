local PhysicsConstants = require(game.ReplicatedStorage.Modules.PhysicsConstants)

-- Grannus Template - Star
local template = Instance.new("Model")
template.Name = "PlanetTemplate_Grannus"

-- Core sphere (main body)
local primaryPart = Instance.new("Part")
primaryPart.Name = "PrimaryPart"
primaryPart.Shape = Enum.PartType.Ball
primaryPart.Size = Vector3.new(
    PhysicsConstants.GRANNUS.RADIUS * 2,
    PhysicsConstants.GRANNUS.RADIUS * 2,
    PhysicsConstants.GRANNUS.RADIUS * 2
)
primaryPart.Position = Vector3.new(0, 0, 0)
primaryPart.Anchored = true
primaryPart.BrickColor = BrickColor.new("Deep orange")
primaryPart.Material = Enum.Material.Neon
primaryPart.Parent = template

-- Add corona layers (outer atmosphere)
for i = 1, 4 do
    local corona = Instance.new("Part")
    corona.Name = "CoronaLayer" .. i
    corona.Shape = Enum.PartType.Ball
    corona.Size = Vector3.new(
        PhysicsConstants.GRANNUS.RADIUS * (2 + i * 0.1),
        PhysicsConstants.GRANNUS.RADIUS * (2 + i * 0.1),
        PhysicsConstants.GRANNUS.RADIUS * (2 + i * 0.1)
    )
    corona.Position = Vector3.new(0, 0, 0)
    corona.Transparency = 0.7 + (i * 0.05)
    corona.BrickColor = BrickColor.new("Really red")
    corona.Material = Enum.Material.Neon
    corona.CanCollide = false
    corona.Parent = template
end

-- Add surface features (solar prominences)
local prominences = {
    {
        name = "Prominence_1",
        size = Vector3.new(200, 50, 100),
        position = Vector3.new(150, 0, 0),
        rotation = CFrame.Angles(0, 0, math.rad(45))
    },
    {
        name = "Prominence_2",
        size = Vector3.new(150, 40, 80),
        position = Vector3.new(-120, 80, 0),
        rotation = CFrame.Angles(0, math.rad(30), math.rad(-30))
    }
}

-- Create prominence features
for _, prominence in ipairs(prominences) do
    local part = Instance.new("Part")
    part.Name = prominence.name
    part.Size = prominence.size
    part.CFrame = CFrame.new(prominence.position) * prominence.rotation
    part.BrickColor = BrickColor.new("Really red")
    part.Material = Enum.Material.Neon
    part.Transparency = 0.3
    part.Parent = template
end

-- Add particle effects for solar activity
local particles = Instance.new("ParticleEmitter")
particles.Rate = 50
particles.Lifetime = NumberRange.new(1, 2)
particles.Speed = NumberRange.new(10, 20)
particles.Color = ColorSequence.new(Color3.fromRGB(255, 100, 0))
particles.Size = NumberSequence.new(20)
particles.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.5),
    NumberSequenceKeypoint.new(1, 1)
})
particles.Parent = primaryPart

template.PrimaryPart = primaryPart

return template
