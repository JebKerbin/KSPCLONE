local PhysicsConstants = require(game.ReplicatedStorage.Modules.PhysicsConstants)

-- Space Junk Template Generator
local template = {}

-- Different types of space debris with their characteristics
local DEBRIS_TYPES = {
    satellite = {
        mainSize = Vector3.new(4, 2, 6),
        color = "Medium stone grey",
        parts = {
            {name = "SolarPanel1", size = Vector3.new(8, 0.2, 2), offset = Vector3.new(6, 0, 0)},
            {name = "SolarPanel2", size = Vector3.new(8, 0.2, 2), offset = Vector3.new(-6, 0, 0)},
            {name = "Antenna", size = Vector3.new(0.5, 4, 0.5), offset = Vector3.new(0, 3, 0)},
            {name = "CommunicationDish", size = Vector3.new(2, 2, 0.5), offset = Vector3.new(0, 1, 3),
             shape = "Cylinder", rotation = CFrame.Angles(math.rad(90), 0, 0)}
        }
    },
    rocketStage = {
        mainSize = Vector3.new(3, 8, 3),
        color = "White",
        parts = {
            {name = "Engine", size = Vector3.new(2, 3, 2), offset = Vector3.new(0, -5.5, 0)},
            {name = "Fins1", size = Vector3.new(1, 3, 1), offset = Vector3.new(2, -4, 0)},
            {name = "Fins2", size = Vector3.new(1, 3, 1), offset = Vector3.new(-2, -4, 0)},
            {name = "Fins3", size = Vector3.new(1, 3, 1), offset = Vector3.new(0, -4, 2)},
            {name = "Fins4", size = Vector3.new(1, 3, 1), offset = Vector3.new(0, -4, -2)}
        }
    },
    debris = {
        mainSize = Vector3.new(math.random(2, 5), math.random(2, 5), math.random(2, 5)),
        color = "Dark grey",
        parts = {
            {name = "Fragment1", size = Vector3.new(math.random(1, 3), math.random(1, 3), math.random(1, 3)),
             offset = Vector3.new(math.random(-2, 2), math.random(-2, 2), math.random(-2, 2))},
            {name = "Fragment2", size = Vector3.new(math.random(1, 2), math.random(1, 2), math.random(1, 2)),
             offset = Vector3.new(math.random(-1, 1), math.random(-1, 1), math.random(-1, 1))}
        }
    }
}

function template.createSpaceJunk(junkType)
    local debris = Instance.new("Model")
    debris.Name = "SpaceJunk_" .. junkType

    local config = DEBRIS_TYPES[junkType] or DEBRIS_TYPES.debris

    -- Main body
    local main = Instance.new("Part")
    main.Name = "Main"
    main.Size = config.mainSize
    main.Position = Vector3.new(0, 0, 0)
    main.BrickColor = BrickColor.new(config.color)
    main.Material = Enum.Material.Metal
    main.Parent = debris

    -- Add additional parts with enhanced features
    for _, partConfig in ipairs(config.parts) do
        local part = Instance.new("Part")
        part.Name = partConfig.name
        part.Size = partConfig.size
        part.Position = main.Position + partConfig.offset
        part.BrickColor = main.BrickColor
        part.Material = Enum.Material.Metal

        -- Apply special shape if specified
        if partConfig.shape == "Cylinder" then
            part.Shape = Enum.PartType.Cylinder
        end

        -- Apply rotation if specified
        if partConfig.rotation then
            part.CFrame = CFrame.new(part.Position) * partConfig.rotation
        end

        part.Parent = debris

        -- Weld to main body
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = main
        weld.Part1 = part
        weld.Parent = part
    end

    -- Add damage effects (burn marks, dents) for visual interest
    if junkType == "debris" then
        local damage = Instance.new("Texture")
        damage.Texture = "rbxasset://textures/SpaceTextures/damage"
        damage.Transparency = 0.7
        damage.Parent = main
    end

    debris.PrimaryPart = main
    return debris
end

return template