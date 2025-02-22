local PhysicsConstants = require(game.ReplicatedStorage.Modules.PhysicsConstants)

-- Kerbol System Main Asteroid Belt Template
local template = Instance.new("Model")
template.Name = "Template_KerbolMainBelt"

-- Create belt container
local beltContainer = Instance.new("Model")
beltContainer.Name = "BeltContainer"
beltContainer.Parent = template

-- Generate asteroid belt segments
local NUM_SEGMENTS = 36
local RADIUS_MIN = 13000 -- Between Duna and Jool
local RADIUS_MAX = 15000
local BELT_HEIGHT = 500

for i = 1, NUM_SEGMENTS do
    local segment = Instance.new("Part")
    segment.Name = "BeltSegment_" .. i
    segment.Anchored = true
    segment.CanCollide = false
    
    -- Create circular segments
    local angle = (i / NUM_SEGMENTS) * math.pi * 2
    local radius = RADIUS_MIN + math.random() * (RADIUS_MAX - RADIUS_MIN)
    
    segment.Position = Vector3.new(
        math.cos(angle) * radius,
        (math.random() - 0.5) * BELT_HEIGHT,
        math.sin(angle) * radius
    )
    
    -- Random sizing for variety
    segment.Size = Vector3.new(
        200 + math.random() * 300,
        50 + math.random() * 100,
        200 + math.random() * 300
    )
    
    -- Asteroid appearance
    segment.BrickColor = BrickColor.new("Dark stone grey")
    segment.Material = Enum.Material.Rock
    segment.Transparency = 0.3 -- Slightly transparent to reduce visual noise
    
    -- Add special mesh for asteroid-like appearance
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.Scale = Vector3.new(1 + math.random() * 0.5, 1 + math.random() * 0.5, 1 + math.random() * 0.5)
    mesh.Parent = segment
    
    segment.Parent = beltContainer
end

return template
