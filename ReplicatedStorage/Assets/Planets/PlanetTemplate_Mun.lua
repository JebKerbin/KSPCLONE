local PhysicsConstants = require(game.ReplicatedStorage.Modules.PhysicsConstants)

-- Mun Template
local template = Instance.new("Model")
template.Name = "PlanetTemplate_Mun"

local primaryPart = Instance.new("Part")
primaryPart.Name = "PrimaryPart"
primaryPart.Size = Vector3.new(
    PhysicsConstants.MUN.RADIUS * 2,
    PhysicsConstants.MUN.RADIUS * 2,
    PhysicsConstants.MUN.RADIUS * 2
)
-- Position Mun at a specific distance from Kerbin
primaryPart.Position = Vector3.new(PhysicsConstants.KERBIN.RADIUS * 4, 0, 0)
primaryPart.Anchored = true
primaryPart.BrickColor = BrickColor.new("Fossil")
primaryPart.Material = Enum.Material.Rock
primaryPart.Parent = template

template.PrimaryPart = primaryPart

return template