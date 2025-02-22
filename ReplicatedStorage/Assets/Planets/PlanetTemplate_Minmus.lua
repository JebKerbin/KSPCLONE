local PhysicsConstants = require(game.ReplicatedStorage.Modules.PhysicsConstants)

-- Minmus Template
local template = Instance.new("Model")
template.Name = "PlanetTemplate_Minmus"

local primaryPart = Instance.new("Part")
primaryPart.Name = "PrimaryPart"
primaryPart.Size = Vector3.new(
    PhysicsConstants.MINMUS.RADIUS * 2,
    PhysicsConstants.MINMUS.RADIUS * 2,
    PhysicsConstants.MINMUS.RADIUS * 2
)
-- Position Minmus at a specific distance from Kerbin with inclination
primaryPart.Position = Vector3.new(0, PhysicsConstants.KERBIN.RADIUS * 6, PhysicsConstants.KERBIN.RADIUS * 6)
primaryPart.Anchored = true
primaryPart.BrickColor = BrickColor.new("Cyan")
primaryPart.Material = Enum.Material.Ice
primaryPart.Parent = template

template.PrimaryPart = primaryPart

return template