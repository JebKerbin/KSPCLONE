local PhysicsConstants = require(game.ReplicatedStorage.Modules.PhysicsConstants)

-- Comet Template Generator
local template = {}

function template.createComet(size, tailLength)
    local comet = Instance.new("Model")
    comet.Name = "Comet"
    
    -- Nucleus (core)
    local nucleus = Instance.new("Part")
    nucleus.Name = "Nucleus"
    nucleus.Shape = Enum.PartType.Ball
    nucleus.Size = Vector3.new(size, size, size)
    nucleus.Position = Vector3.new(0, 0, 0)
    nucleus.Anchored = true
    nucleus.BrickColor = BrickColor.new("Institutional white")
    nucleus.Material = Enum.Material.Ice
    nucleus.Parent = comet
    
    -- Create tail segments
    local NUM_SEGMENTS = 10
    for i = 1, NUM_SEGMENTS do
        local segment = Instance.new("Part")
        segment.Name = "TailSegment_" .. i
        
        -- Tail gets progressively smaller and more transparent
        local segmentSize = size * (1 - i/NUM_SEGMENTS * 0.7)
        segment.Size = Vector3.new(segmentSize, segmentSize, tailLength/NUM_SEGMENTS)
        segment.Position = Vector3.new(0, 0, -i * tailLength/NUM_SEGMENTS)
        
        segment.Transparency = i/NUM_SEGMENTS * 0.9
        segment.BrickColor = BrickColor.new("Light blue")
        segment.Material = Enum.Material.Neon
        segment.CanCollide = false
        segment.Parent = comet
    end
    
    -- Add ice particles
    local particles = Instance.new("ParticleEmitter")
    particles.Rate = 50
    particles.Lifetime = NumberRange.new(1, 2)
    particles.Speed = NumberRange.new(10, 20)
    particles.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    particles.Size = NumberSequence.new(size * 0.1)
    particles.Parent = nucleus
    
    comet.PrimaryPart = nucleus
    return comet
end

return template
