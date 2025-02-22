local PhysicsConstants = require(game.ReplicatedStorage.Modules.PhysicsConstants)

-- Random Asteroid Template Generator
local template = {}

-- Asteroid types with their characteristics
local ASTEROID_TYPES = {
    rocky = {
        colors = {"Dark stone grey", "Really black", "Medium stone grey"},
        materials = {Enum.Material.Rock, Enum.Material.Slate},
        roughness = 0.8
    },
    icy = {
        colors = {"Institutional white", "Ghost grey", "White"},
        materials = {Enum.Material.Ice, Enum.Material.Glass},
        roughness = 0.5
    },
    metallic = {
        colors = {"Medium stone grey", "Dark grey metallic", "Deep orange"},
        materials = {Enum.Material.Metal, Enum.Material.DiamondPlate},
        roughness = 0.3
    }
}

function template.createAsteroid(size, asteroidType)
    local asteroid = Instance.new("Model")
    asteroid.Name = "RandomAsteroid"

    -- Determine asteroid type
    asteroidType = asteroidType or "rocky"
    local typeConfig = ASTEROID_TYPES[asteroidType]

    -- Core part with random deformation
    local core = Instance.new("Part")
    core.Name = "Core"
    core.Shape = Enum.PartType.Ball
    -- Add some randomness to the size
    local sizeVariation = size * 0.2
    core.Size = Vector3.new(
        size + math.random(-sizeVariation, sizeVariation),
        size + math.random(-sizeVariation, sizeVariation),
        size + math.random(-sizeVariation, sizeVariation)
    )
    core.Position = Vector3.new(0, 0, 0)
    core.Anchored = true
    core.BrickColor = BrickColor.new(typeConfig.colors[1])
    core.Material = typeConfig.materials[1]
    core.Parent = asteroid

    -- Add surface details with more variety
    local numDetails = math.random(5, 10)
    for i = 1, numDetails do
        local detail = Instance.new("Part")
        detail.Name = "Detail_" .. i
        -- Vary detail sizes more
        detail.Size = Vector3.new(
            size * (0.2 + 0.3 * math.random()),
            size * (0.2 + 0.3 * math.random()),
            size * (0.2 + 0.3 * math.random())
        )

        -- Position around core with more variation
        local angle = (i / numDetails) * math.pi * 2
        local radius = size * (0.3 + 0.2 * math.random())
        detail.Position = Vector3.new(
            math.cos(angle) * radius,
            math.sin(angle) * radius,
            math.random(-size * 0.3, size * 0.3)
        )

        -- Randomly select color and material from type config
        detail.BrickColor = BrickColor.new(typeConfig.colors[math.random(1, #typeConfig.colors)])
        detail.Material = typeConfig.materials[math.random(1, #typeConfig.materials)]

        -- Add mesh for more interesting shapes
        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.Scale = Vector3.new(1, 1, 1)
        -- Random rotation for variety
        mesh.Offset = Vector3.new(
            math.random(-1, 1),
            math.random(-1, 1),
            math.random(-1, 1)
        )
        mesh.Parent = detail

        detail.Parent = asteroid

        -- Weld to core
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = core
        weld.Part1 = detail
        weld.Parent = detail
    end

    -- Add particle effects based on type
    local particles = Instance.new("ParticleEmitter")
    particles.Rate = 5
    particles.Lifetime = NumberRange.new(1, 2)
    particles.Speed = NumberRange.new(1, 2)
    particles.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, size * 0.05),
        NumberSequenceKeypoint.new(1, 0)
    })

    -- Set particle color based on type
    if asteroidType == "icy" then
        particles.Color = ColorSequence.new(Color3.fromRGB(200, 200, 255))
    elseif asteroidType == "metallic" then
        particles.Color = ColorSequence.new(Color3.fromRGB(180, 180, 180))
    else
        particles.Color = ColorSequence.new(Color3.fromRGB(100, 100, 100))
    end

    particles.Parent = core

    asteroid.PrimaryPart = core
    return asteroid
end

return template