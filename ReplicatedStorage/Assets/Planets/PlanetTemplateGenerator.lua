local PhysicsConstants = require(game.ReplicatedStorage.Modules.PhysicsConstants)
local OrbitalMotion = require(game.ReplicatedStorage.Modules.OrbitalMotion)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Cache frequently used constructors
local Instance_new = Instance.new
local CFrame_new = CFrame.new
local Vector3_new = Vector3.new
local cos = math.cos
local sin = math.sin
local pi = math.pi

-- Object pool for atmosphere parts
local atmospherePool = {
    parts = {},
    inUse = {}
}

-- Get or create atmosphere from pool
local function getAtmospherePart()
    local part = table.remove(atmospherePool.parts)
    if not part then
        part = Instance_new("Part")
        part.Name = "Atmosphere"
        part.Shape = Enum.PartType.Ball
        part.CanCollide = false
        part.Transparency = 0.8
        part.BrickColor = BrickColor.new("Light blue")
        part.Material = Enum.Material.ForceField
    end
    atmospherePool.inUse[part] = true
    return part
end

-- Return atmosphere to pool
local function returnAtmospherePart(part)
    if atmospherePool.inUse[part] then
        atmospherePool.inUse[part] = nil
        table.insert(atmospherePool.parts, part)
        part.Parent = nil
    end
end

-- Optimized relative position calculation
local function getRelativePosition(bodyName)
    if bodyName == "KERBOL" or bodyName == "CIRO" then
        return CFrame_new(0, 0, 0)
    end

    local parentName = PhysicsConstants[bodyName].PARENT or "KERBOL"
    if bodyName == "GLUMO" then
        parentName = "GARGANTUA"
    elseif bodyName == "MAYOR" or bodyName == "REGENT" then
        parentName = "OVIN"
    end

    local orbitRadius = PhysicsConstants[bodyName].ORBIT_RADIUS

    -- Custom positioning logic for different star systems
    if parentName == "KERBOL" or parentName == "CIRO" then
        -- Position planets in a spiral around their star
        local planets = {"MOHO", "EVE", "KERBIN", "DUNA", "DRES", "JOOL", "EELOO", "GARGANTUA", "OVIN"}
        local index = table.find(planets, bodyName) or 1
        local angle = index * (pi / 4)
        return CFrame_new(
            cos(angle) * orbitRadius,
            sin(angle) * orbitRadius,
            0
        )
    elseif parentName == "KERBIN" then
        -- Position Kerbin's moons
        if bodyName == "MUN" then
            return CFrame_new(orbitRadius, 0, 0)
        else -- Minmus
            return CFrame_new(0, orbitRadius * 0.7071, orbitRadius * 0.7071)
        end
    elseif parentName == "JOOL" then
        -- Position Jool's moons in a spiral
        local moons = {"LAYTHE", "VALL", "TYLO", "BOP", "POL"}
        local index = table.find(moons, bodyName) or 1
        local angle = index * (pi / 3)
        return CFrame_new(
            cos(angle) * orbitRadius,
            sin(angle) * orbitRadius,
            0
        )
    elseif parentName == "GARGANTUA" or parentName == "OVIN" then
        -- Position moons of KSP2 planets
        local angle = (bodyName == "MAYOR" or bodyName == "GLUMO") and 0 or pi/2
        return CFrame_new(
            cos(angle) * orbitRadius,
            sin(angle) * orbitRadius,
            0
        )
    else
        -- Default positioning for other moons
        return CFrame_new(orbitRadius, 0, 0)
    end
end

local PlanetTemplateGenerator = {}

function PlanetTemplateGenerator.createTemplate(bodyName)
    -- Load pre-existing model from ReplicatedStorage.Assets.Planets
    local template = ReplicatedStorage.Assets.Planets["PlanetTemplate_" .. bodyName]:Clone()
    if not template then
        warn(string.format("[PlanetTemplateGenerator] Could not find template for %s", bodyName))
        return nil
    end
    template.Name = bodyName

    -- Get the primary part (should be pre-configured in the template)
    local primaryPart = template.PrimaryPart
    if not primaryPart then
        warn(string.format("[PlanetTemplateGenerator] Model %s has no PrimaryPart set", bodyName))
        return nil
    end

    -- Set position using optimized CFrame calculation
    template:SetPrimaryPartCFrame(getRelativePosition(bodyName))

    -- Add atmosphere if applicable using object pool
    if PhysicsConstants[bodyName].ATMOSPHERE_HEIGHT then
        local atmosphere = getAtmospherePart()
        atmosphere.Size = Vector3_new(
            primaryPart.Size.X + PhysicsConstants[bodyName].ATMOSPHERE_HEIGHT * 2,
            primaryPart.Size.Y + PhysicsConstants[bodyName].ATMOSPHERE_HEIGHT * 2,
            primaryPart.Size.Z + PhysicsConstants[bodyName].ATMOSPHERE_HEIGHT * 2
        )
        atmosphere.CFrame = template:GetPrimaryPartCFrame()
        atmosphere.Parent = template

        -- Set up cleanup for atmosphere
        template.AncestryChanged:Connect(function(_, parent)
            if not parent then
                returnAtmospherePart(atmosphere)
            end
        end)
    end

    -- Store parent information as attribute
    if PhysicsConstants[bodyName].PARENT then
        template:SetAttribute("ParentBody", PhysicsConstants[bodyName].PARENT)
    end

    -- Set up proper cleanup
    template.AncestryChanged:Connect(function(_, parent)
        if not parent then
            local orbitConnection = template:GetAttribute(template.Name .. "_OrbitConnection")
            if orbitConnection then
                RunService:UnbindFromRenderStep(orbitConnection)
            end
        end
    end)

    return template
end

-- Start orbiting all moons around their parent bodies
function PlanetTemplateGenerator.startOrbits(celestialBodies)
    for bodyName, body in pairs(celestialBodies) do
        local parentName = body:GetAttribute("ParentBody")
        if parentName and celestialBodies[parentName] then
            local parentBody = celestialBodies[parentName]
            local orbitRadius = PhysicsConstants[bodyName].ORBIT_RADIUS

            -- Add inclination for specific bodies
            local inclination = nil
            if bodyName == "MINMUS" then
                inclination = math.rad(6) -- 6-degree inclination for Minmus
            elseif bodyName == "REGENT" then
                inclination = math.rad(12) -- 12-degree inclination for Regent
            end

            OrbitalMotion.startOrbiting(body, parentBody, orbitRadius, inclination)
        end
    end
end

return PlanetTemplateGenerator