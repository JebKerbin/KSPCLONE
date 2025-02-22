local PhysicsConstants = require(game.ReplicatedStorage.Modules.PhysicsConstants)

-- Eve Template - Planet with Thick Atmosphere
local template = Instance.new("Model")
template.Name = "PlanetTemplate_Eve"

-- Core body using eight quarter-circle MeshParts
local mainBody = Instance.new("Model")
mainBody.Name = "MainBody"
mainBody.Parent = template

-- Create the eight quarter-circle segments
for i = 1, 8 do
    local segment = Instance.new("Part")
    segment.Name = "Segment_" .. i
    segment.Size = Vector3.new(
        PhysicsConstants.EVE.RADIUS * 0.5,
        PhysicsConstants.EVE.RADIUS * 0.5,
        PhysicsConstants.EVE.RADIUS * 0.5
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

    segment.BrickColor = BrickColor.new("Royal purple")
    segment.Material = Enum.Material.SmoothPlastic
    mesh.Parent = segment
    segment.Parent = mainBody
end

-- Add terrain features (mountains and valleys)
local terrainFeatures = {
    {
        name = "MountainRange1",
        size = Vector3.new(250, 40, 180),
        position = Vector3.new(-100, 150, 0),
        color = "Dark purple",
        material = Enum.Material.Rock
    },
    {
        name = "MountainRange2",
        size = Vector3.new(200, 35, 160),
        position = Vector3.new(80, -140, 30),
        color = "Royal purple",
        material = Enum.Material.Rock
    },
    {
        name = "Valley1",
        size = Vector3.new(300, 20, 200),
        position = Vector3.new(0, 0, 170),
        color = "Dark indigo",
        material = Enum.Material.Slate
    }
}

-- Create terrain pieces
for _, feature in ipairs(terrainFeatures) do
    local part = Instance.new("Part")
    part.Name = feature.name
    part.Size = feature.size
    part.Position = feature.position
    part.BrickColor = BrickColor.new(feature.color)
    part.Material = feature.material
    -- Use mesh for terrain shaping
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.Scale = Vector3.new(1, 0.3, 1)
    mesh.Parent = part
    part.Parent = template
end

-- Add liquid surface areas (oceans)
local oceans = {
    {
        name = "Ocean_North",
        size = Vector3.new(280, 10, 280),
        position = Vector3.new(0, 160, 0),
        scale = Vector3.new(1, 0.05, 1)
    },
    {
        name = "Ocean_South",
        size = Vector3.new(260, 10, 260),
        position = Vector3.new(0, -150, 0),
        scale = Vector3.new(1, 0.05, 1)
    }
}

-- Create ocean pieces
for _, ocean in ipairs(oceans) do
    local part = Instance.new("Part")
    part.Name = ocean.name
    part.Size = ocean.size
    part.Position = ocean.position
    part.BrickColor = BrickColor.new("Deep blue")
    part.Material = Enum.Material.Neon
    part.Transparency = 0.3
    -- Use mesh for ocean surface
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.Scale = ocean.scale
    mesh.Parent = part
    part.Parent = template
end

-- Add thick atmosphere layers with particle effects
for i = 1, 4 do
    local atmosphere = Instance.new("Part")
    atmosphere.Name = "AtmosphereLayer" .. i
    atmosphere.Shape = Enum.PartType.Ball
    atmosphere.Size = Vector3.new(
        PhysicsConstants.EVE.RADIUS * 2 + (PhysicsConstants.EVE.ATMOSPHERE_HEIGHT * i/3),
        PhysicsConstants.EVE.RADIUS * 2 + (PhysicsConstants.EVE.ATMOSPHERE_HEIGHT * i/3),
        PhysicsConstants.EVE.RADIUS * 2 + (PhysicsConstants.EVE.ATMOSPHERE_HEIGHT * i/3)
    )
    atmosphere.Position = Vector3.new(0, 0, 0)
    atmosphere.Transparency = 0.75 + (i * 0.05)
    atmosphere.BrickColor = BrickColor.new("Light purple")
    atmosphere.Material = Enum.Material.Neon
    atmosphere.CanCollide = false

    -- Add atmospheric particles
    local particles = Instance.new("ParticleEmitter")
    particles.Rate = 25
    particles.Lifetime = NumberRange.new(3, 6)
    particles.Speed = NumberRange.new(1, 2)
    particles.Rotation = NumberRange.new(0, 360)
    particles.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 8),
        NumberSequenceKeypoint.new(1, 4)
    })
    particles.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.6),
        NumberSequenceKeypoint.new(1, 1)
    })
    particles.Color = ColorSequence.new(Color3.fromRGB(147, 112, 219))
    particles.Parent = atmosphere

    atmosphere.Parent = template
end

template.PrimaryPart = mainBody:FindFirstChild("Segment_1")

return template