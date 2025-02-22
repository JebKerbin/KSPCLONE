local PhysicsConstants = require(game.ReplicatedStorage.Modules.PhysicsConstants)

local PlanetTemplateGenerator = {}

-- Color and material mappings for celestial bodies
local PLANET_PROPERTIES = {
    KERBOL = {
        COLOR = "Deep orange",
        MATERIAL = Enum.Material.Neon,
        PARENT = nil
    },
    MOHO = {
        COLOR = "Dark stone grey",
        MATERIAL = Enum.Material.Rock,
        PARENT = "KERBOL"
    },
    EVE = {
        COLOR = "Royal purple",
        MATERIAL = Enum.Material.Slate,
        PARENT = "KERBOL"
    },
    GILLY = {
        COLOR = "Brown",
        MATERIAL = Enum.Material.Rock,
        PARENT = "EVE"
    },
    KERBIN = {
        COLOR = "Earth blue",
        MATERIAL = Enum.Material.Slate,
        PARENT = "KERBOL"
    },
    MUN = {
        COLOR = "Fossil",
        MATERIAL = Enum.Material.Rock,
        PARENT = "KERBIN"
    },
    MINMUS = {
        COLOR = "Cyan",
        MATERIAL = Enum.Material.Ice,
        PARENT = "KERBIN"
    },
    DUNA = {
        COLOR = "Dark orange",
        MATERIAL = Enum.Material.Sand,
        PARENT = "KERBOL"
    },
    IKE = {
        COLOR = "Dark stone grey",
        MATERIAL = Enum.Material.Rock,
        PARENT = "DUNA"
    },
    DRES = {
        COLOR = "Medium stone grey",
        MATERIAL = Enum.Material.Rock,
        PARENT = "KERBOL"
    },
    JOOL = {
        COLOR = "Bright green",
        MATERIAL = Enum.Material.SmoothPlastic,
        PARENT = "KERBOL"
    },
    LAYTHE = {
        COLOR = "Navy blue",
        MATERIAL = Enum.Material.Slate,
        PARENT = "JOOL"
    },
    VALL = {
        COLOR = "Ghost grey",
        MATERIAL = Enum.Material.Ice,
        PARENT = "JOOL"
    },
    TYLO = {
        COLOR = "Sand",
        MATERIAL = Enum.Material.Rock,
        PARENT = "JOOL"
    },
    BOP = {
        COLOR = "Reddish brown",
        MATERIAL = Enum.Material.Rock,
        PARENT = "JOOL"
    },
    POL = {
        COLOR = "Khaki",
        MATERIAL = Enum.Material.Sand,
        PARENT = "JOOL"
    },
    EELOO = {
        COLOR = "White",
        MATERIAL = Enum.Material.Ice,
        PARENT = "KERBOL"
    },
    -- KSP2 Additions
    OVIN = {
        COLOR = "Sand red",
        MATERIAL = Enum.Material.Rock,
        PARENT = "KERBOL"
    },
    GARGANTUA = {
        COLOR = "Really black",
        MATERIAL = Enum.Material.Neon,
        PARENT = "KERBOL"
    },
    GLUMO = {
        COLOR = "Medium stone grey",
        MATERIAL = Enum.Material.Rock,
        PARENT = "GARGANTUA"
    }
}

-- Generate relative positions for bodies
local function getRelativePosition(bodyName)
    local props = PLANET_PROPERTIES[bodyName]
    local parent = props.PARENT
    
    if not parent then
        return Vector3.new(0, 0, 0) -- Kerbol at center
    end
    
    local parentRadius = PhysicsConstants[parent].RADIUS
    local orbitMultiplier = 4 -- Base orbit distance multiplier
    
    -- Custom positioning logic for different bodies
    if parent == "KERBOL" then
        -- Position planets in a spiral around Kerbol
        local index = table.find({"MOHO", "EVE", "KERBIN", "DUNA", "DRES", "JOOL", "EELOO", "OVIN", "GARGANTUA"}, bodyName) or 1
        local angle = index * (math.pi / 4)
        local distance = parentRadius * (orbitMultiplier * index)
        return Vector3.new(
            math.cos(angle) * distance,
            math.sin(angle) * distance,
            0
        )
    elseif parent == "KERBIN" then
        -- Position Kerbin's moons
        if bodyName == "MUN" then
            return Vector3.new(parentRadius * 4, 0, 0)
        else -- Minmus
            return Vector3.new(0, parentRadius * 6, parentRadius * 6)
        end
    elseif parent == "JOOL" then
        -- Position Jool's moons in a spiral
        local moons = {"LAYTHE", "VALL", "TYLO", "BOP", "POL"}
        local index = table.find(moons, bodyName) or 1
        local angle = index * (math.pi / 3)
        local distance = parentRadius * (2 + index)
        return Vector3.new(
            math.cos(angle) * distance,
            math.sin(angle) * distance,
            0
        )
    else
        -- Default moon positioning
        return Vector3.new(parentRadius * 3, 0, 0)
    end
end

function PlanetTemplateGenerator.createTemplate(bodyName)
    local template = Instance.new("Model")
    template.Name = "PlanetTemplate_" .. bodyName
    
    local primaryPart = Instance.new("Part")
    primaryPart.Name = "PrimaryPart"
    primaryPart.Size = Vector3.new(
        PhysicsConstants[bodyName].RADIUS * 2,
        PhysicsConstants[bodyName].RADIUS * 2,
        PhysicsConstants[bodyName].RADIUS * 2
    )
    
    primaryPart.Position = getRelativePosition(bodyName)
    primaryPart.Anchored = true
    primaryPart.BrickColor = BrickColor.new(PLANET_PROPERTIES[bodyName].COLOR)
    primaryPart.Material = PLANET_PROPERTIES[bodyName].MATERIAL
    
    -- Add atmosphere if applicable
    if PhysicsConstants[bodyName].ATMOSPHERE_HEIGHT then
        local atmosphere = Instance.new("Part")
        atmosphere.Name = "Atmosphere"
        atmosphere.Shape = Enum.PartType.Ball
        atmosphere.Size = Vector3.new(
            PhysicsConstants[bodyName].RADIUS * 2 + PhysicsConstants[bodyName].ATMOSPHERE_HEIGHT * 2,
            PhysicsConstants[bodyName].RADIUS * 2 + PhysicsConstants[bodyName].ATMOSPHERE_HEIGHT * 2,
            PhysicsConstants[bodyName].RADIUS * 2 + PhysicsConstants[bodyName].ATMOSPHERE_HEIGHT * 2
        )
        atmosphere.Position = primaryPart.Position
        atmosphere.Anchored = true
        atmosphere.CanCollide = false
        atmosphere.Transparency = 0.8
        atmosphere.BrickColor = BrickColor.new("Light blue")
        atmosphere.Material = Enum.Material.ForceField
        atmosphere.Parent = template
    end
    
    primaryPart.Parent = template
    template.PrimaryPart = primaryPart
    
    return template
end

return PlanetTemplateGenerator
