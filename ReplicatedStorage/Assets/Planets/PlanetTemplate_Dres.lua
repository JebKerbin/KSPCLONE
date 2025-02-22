local PhysicsConstants = require(game.ReplicatedStorage.Modules.PhysicsConstants)

-- Dres Template - Asteroid-like Planet with Rings
local template = Instance.new("Model")
template.Name = "PlanetTemplate_Dres"

-- Core sphere (main body) using eight quarter-circle MeshParts
local mainBody = Instance.new("Model")
mainBody.Name = "MainBody"
mainBody.Parent = template

-- Create the eight quarter-circle segments
for i = 1, 8 do
    local segment = Instance.new("Part")
    segment.Name = "Segment_" .. i
    segment.Size = Vector3.new(
        PhysicsConstants.DRES.RADIUS * 0.5,
        PhysicsConstants.DRES.RADIUS * 0.5,
        PhysicsConstants.DRES.RADIUS * 0.5
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

    segment.BrickColor = BrickColor.new("Medium stone grey")
    segment.Material = Enum.Material.Rock
    mesh.Parent = segment
    segment.Parent = mainBody
end

-- Add ring system
local ringSystem = Instance.new("Model")
ringSystem.Name = "RingSystem"

-- Create multiple ring layers for depth
for i = 1, 3 do
    local ring = Instance.new("Part")
    ring.Name = "Ring_" .. i
    local radius = PhysicsConstants.DRES.RADIUS * (1.5 + i * 0.2)
    ring.Size = Vector3.new(radius * 2, 0.5, radius * 2)
    ring.Position = Vector3.new(0, 0, 0)
    ring.Transparency = 0.3 + (i * 0.2) -- Outer rings more transparent
    ring.BrickColor = BrickColor.new("Dark stone grey")
    ring.Material = Enum.Material.Neon
    ring.CanCollide = false

    -- Create ring mesh
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.Cylinder
    mesh.Scale = Vector3.new(1, 0.01, 1) -- Very thin cylinder
    mesh.Parent = ring

    -- Add asteroid particles to represent ring debris
    local particles = Instance.new("ParticleEmitter")
    particles.Rate = 10
    particles.Lifetime = NumberRange.new(2, 4)
    particles.Speed = NumberRange.new(1, 2)
    particles.Rotation = NumberRange.new(0, 360)
    particles.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 2),
        NumberSequenceKeypoint.new(1, 1)
    })
    particles.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.2),
        NumberSequenceKeypoint.new(1, 1)
    })
    particles.Color = ColorSequence.new(Color3.fromRGB(169, 169, 169))
    particles.Parent = ring

    ring.Parent = ringSystem
end

ringSystem.Parent = template

-- Add major craters
local craters = {
    {
        name = "Crater_Alpha",
        size = Vector3.new(80, 20, 80),
        position = Vector3.new(40, 30, 0),
        scale = Vector3.new(1, 0.2, 1)
    },
    {
        name = "Crater_Beta",
        size = Vector3.new(60, 15, 60),
        position = Vector3.new(-30, -20, 30),
        scale = Vector3.new(1, 0.15, 1)
    },
    {
        name = "Crater_Gamma",
        size = Vector3.new(70, 18, 70),
        position = Vector3.new(10, 50, 20),
        scale = Vector3.new(1, 0.18, 1)
    }
}

-- Create crater pieces
for _, crater in ipairs(craters) do
    local part = Instance.new("Part")
    part.Name = crater.name
    part.Size = crater.size
    part.Position = crater.position
    part.BrickColor = BrickColor.new("Dark stone grey")
    part.Material = Enum.Material.Slate
    -- Use mesh for crater shape
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.Cylinder
    mesh.Scale = crater.scale
    mesh.Parent = part
    part.Parent = template
end

-- Add ridges and valleys
local terrain = {
    {
        name = "Ridge_North",
        size = Vector3.new(90, 25, 40),
        position = Vector3.new(20, 60, 0),
        rotation = CFrame.Angles(0, math.rad(45), math.rad(15))
    },
    {
        name = "Valley_South",
        size = Vector3.new(100, 20, 50),
        position = Vector3.new(-25, -50, 20),
        rotation = CFrame.Angles(math.rad(30), 0, math.rad(-20))
    }
}

-- Create terrain features
for _, feature in ipairs(terrain) do
    local part = Instance.new("Part")
    part.Name = feature.name
    part.Size = feature.size
    part.CFrame = CFrame.new(feature.position) * feature.rotation
    part.BrickColor = BrickColor.new("Dark stone grey")
    part.Material = Enum.Material.Rock
    part.Parent = template
end

-- Add surface details (boulders and rocks)
for i = 1, 10 do
    local boulder = Instance.new("Part")
    boulder.Name = "Boulder_" .. i
    boulder.Shape = Enum.PartType.Ball
    boulder.Size = Vector3.new(10 + math.random(-3, 3), 8 + math.random(-2, 2), 10 + math.random(-3, 3))
    -- Distribute boulders around the surface
    local angle = (i / 10) * math.pi * 2
    boulder.Position = Vector3.new(
        math.cos(angle) * 30,
        math.sin(angle) * 30,
        math.random(-10, 10)
    )
    boulder.BrickColor = BrickColor.new("Medium stone grey")
    boulder.Material = Enum.Material.Rock
    boulder.Parent = template
end

template.PrimaryPart = mainBody:FindFirstChild("Segment_1")

return template