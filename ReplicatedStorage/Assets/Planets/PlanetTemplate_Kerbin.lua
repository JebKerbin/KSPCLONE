local PhysicsConstants = require(game.ReplicatedStorage.Modules.PhysicsConstants)

-- Kerbin Template
local template = Instance.new("Model")
template.Name = "PlanetTemplate_Kerbin"

local primaryPart = Instance.new("Part")
primaryPart.Name = "PrimaryPart"
primaryPart.Size = Vector3.new(
    PhysicsConstants.KERBIN.RADIUS * 2,
    PhysicsConstants.KERBIN.RADIUS * 2,
    PhysicsConstants.KERBIN.RADIUS * 2
)
primaryPart.Position = Vector3.new(0, 0, 0)
primaryPart.Anchored = true
primaryPart.BrickColor = BrickColor.new("Earth blue")
primaryPart.Material = Enum.Material.Slate
primaryPart.Parent = template

template.PrimaryPart = primaryPart

return template