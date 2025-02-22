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

-- Debug logging function
local function logDebug(bodyName, message, ...)
    print(string.format("[PlanetTemplateGenerator][%s] %s", bodyName, message:format(...)))
end

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

-- Weld all pieces of a planet together
local function weldPlanetPieces(model)
    local primaryPart = model.PrimaryPart
    if not primaryPart then return end

    local weldCount = 0
    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") and part ~= primaryPart then
            local weld = Instance_new("WeldConstraint")
            weld.Part0 = primaryPart
            weld.Part1 = part
            weld.Parent = part
            weldCount = weldCount + 1
        end
    end

    logDebug(model.Name, "Welded %d pieces to primary part", weldCount)
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

    -- Position planets in a spiral around their star
    if parentName == "KERBOL" or parentName == "CIRO" then
        local planets = {"MOHO", "EVE", "KERBIN", "DUNA", "DRES", "JOOL", "EELOO", "GARGANTUA", "OVIN"}
        local index = table.find(planets, bodyName) or 1
        local angle = index * (pi / 4)
        return CFrame_new(
            cos(angle) * orbitRadius,
            sin(angle) * orbitRadius,
            0
        )
    elseif parentName == "KERBIN" then
        -- Position Kerbin's moons with inclination
        if bodyName == "MUN" then
            return CFrame_new(orbitRadius, 0, 0)
        else -- Minmus
            return CFrame_new(0, orbitRadius * 0.7071, orbitRadius * 0.7071)
        end
    else
        -- Default moon positioning with spiral pattern
        local moonIndex = 1
        if parentName == "JOOL" then
            local moons = {"LAYTHE", "VALL", "TYLO", "BOP", "POL"}
            moonIndex = table.find(moons, bodyName) or 1
        end
        local angle = moonIndex * (pi / 3)
        return CFrame_new(
            cos(angle) * orbitRadius,
            sin(angle) * orbitRadius,
            0
        )
    end
end

local PlanetTemplateGenerator = {}

function PlanetTemplateGenerator.createTemplate(bodyName)
    logDebug(bodyName, "Creating celestial body template")

    -- Determine template type and location
    local templatePath = "PlanetTemplate_" .. bodyName
    local templateFolder = "Planets"

    -- Check body type and adjust path
    if string.find(bodyName, "MUN") or string.find(bodyName, "MINMUS") or
       string.find(bodyName, "LAYTHE") or string.find(bodyName, "VALL") or
       string.find(bodyName, "TYLO") or string.find(bodyName, "BOP") or
       string.find(bodyName, "POL") or string.find(bodyName, "IKE") then
        templateFolder = "Moons"
        templatePath = "Template_" .. bodyName:sub(1,1) .. bodyName:sub(2):lower()
    elseif string.find(bodyName, "BELT") then
        templateFolder = "AsteroidBelt"
        templatePath = "Template_" .. bodyName
    elseif string.find(bodyName, "ASTEROID") or string.find(bodyName, "COMET") then
        templateFolder = "SpaceObjects"
        templatePath = "Template_" .. bodyName
    elseif string.find(bodyName, "DEBRIS") then
        templateFolder = "SpaceDebris"
        templatePath = "Template_" .. bodyName
    end

    -- Load pre-existing model from appropriate folder
    local template = ReplicatedStorage.Assets[templateFolder][templatePath]:Clone()
    if not template then
        warn(string.format("[PlanetTemplateGenerator] Could not find template for %s in %s", bodyName, templateFolder))
        return nil
    end
    template.Name = bodyName

    -- Get the primary part (should be pre-configured in the template)
    local primaryPart = template.PrimaryPart
    if not primaryPart then
        warn(string.format("[PlanetTemplateGenerator] Model %s has no PrimaryPart set", bodyName))
        return nil
    end

    -- Verify model scale matches physics constants
    local size = template:GetExtentsSize()
    local expectedDiameter = PhysicsConstants[bodyName].RADIUS * 2
    local scaleDiff = math.abs(size.X - expectedDiameter) / expectedDiameter
    if scaleDiff > 0.1 then -- Allow 10% difference
        logDebug(bodyName, "Warning: Model size (%0.2f) differs from expected diameter (%0.2f)", 
            size.X, expectedDiameter)
    end

    -- Weld all pieces together
    weldPlanetPieces(template)

    -- Set position using optimized CFrame calculation
    local position = getRelativePosition(bodyName)
    template:SetPrimaryPartCFrame(position)
    logDebug(bodyName, "Positioned at (%.1f, %.1f, %.1f)", 
        position.X, position.Y, position.Z)

    -- Add atmosphere if applicable using object pool
    if PhysicsConstants[bodyName].ATMOSPHERE_HEIGHT then
        local atmosphere = getAtmospherePart()
        -- Calculate atmosphere size based on the model's bounding box
        local maxExtent = math.max(size.X, size.Y, size.Z)
        local atmosphereSize = maxExtent + PhysicsConstants[bodyName].ATMOSPHERE_HEIGHT * 2
        atmosphere.Size = Vector3_new(atmosphereSize, atmosphereSize, atmosphereSize)
        atmosphere.CFrame = template:GetPrimaryPartCFrame()
        atmosphere.Parent = template

        logDebug(bodyName, "Added atmosphere with size %.1f (base size %.1f + height %.1f)",
            atmosphereSize, maxExtent, PhysicsConstants[bodyName].ATMOSPHERE_HEIGHT * 2)

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
        logDebug(bodyName, "Set parent body to %s", PhysicsConstants[bodyName].PARENT)
    end

    -- Set up proper cleanup
    template.AncestryChanged:Connect(function(_, parent)
        if not parent then
            local orbitConnection = template:GetAttribute(template.Name .. "_OrbitConnection")
            if orbitConnection then
                RunService:UnbindFromRenderStep(orbitConnection)
                logDebug(bodyName, "Cleaned up orbit connection")
            end
        end
    end)

    logDebug(bodyName, "Template creation complete")
    return template
end

-- Add new functions for space object generation
function PlanetTemplateGenerator.createRandomAsteroid(size)
    local asteroidTemplate = require(ReplicatedStorage.Assets.SpaceObjects.Template_RandomAsteroid)
    return asteroidTemplate.createAsteroid(size or math.random(10, 30))
end

function PlanetTemplateGenerator.createComet(size, tailLength)
    local cometTemplate = require(ReplicatedStorage.Assets.SpaceObjects.Template_Comet)
    return cometTemplate.createComet(size or math.random(20, 40), tailLength or math.random(100, 200))
end

function PlanetTemplateGenerator.createSpaceJunk(junkType)
    local junkTemplate = require(ReplicatedStorage.Assets.SpaceDebris.Template_SpaceJunk)
    return junkTemplate.createSpaceJunk(junkType or "debris")
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
            logDebug(bodyName, "Started orbiting around %s at radius %.1f with inclination %s",
                parentName, orbitRadius, inclination and string.format("%.1f°", math.deg(inclination)) or "none")
        end
    end
end

return PlanetTemplateGenerator