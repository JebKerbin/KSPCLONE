local PhysicsConstants = require(game.ReplicatedStorage.Modules.PhysicsConstants)
local OrbitalMotion = require(game.ReplicatedStorage.Modules.OrbitalMotion)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Debug logging function
local function logDebug(bodyName, message, ...)
    print(string.format("[PlanetTemplateGenerator][%s] %s", bodyName, message:format(...)))
end

-- Optimized relative position calculation
local function getRelativePosition(bodyName)
    if bodyName == "KERBOL" or bodyName == "CIRO" then
        return CFrame.new(0, 0, 0)
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
        local angle = index * (math.pi / 4)
        return CFrame.new(
            math.cos(angle) * orbitRadius,
            math.sin(angle) * orbitRadius,
            0
        )
    elseif parentName == "KERBIN" then
        -- Position Kerbin's moons with inclination
        if bodyName == "MUN" then
            return CFrame.new(orbitRadius, 0, 0)
        else -- Minmus
            return CFrame.new(0, orbitRadius * 0.7071, orbitRadius * 0.7071)
        end
    else
        -- Default moon positioning with spiral pattern
        local moonIndex = 1
        if parentName == "JOOL" then
            local moons = {"LAYTHE", "VALL", "TYLO", "BOP", "POL"}
            moonIndex = table.find(moons, bodyName) or 1
        end
        local angle = moonIndex * (math.pi / 3)
        return CFrame.new(
            math.cos(angle) * orbitRadius,
            math.sin(angle) * orbitRadius,
            0
        )
    end
end

local PlanetTemplateGenerator = {}

function PlanetTemplateGenerator.createTemplate(bodyName)
    logDebug(bodyName, "Creating celestial body template")

    -- Determine template type and location
    local templatePath
    local templateFolder = "Models" -- Default folder for Roblox Studio models

    -- Check body type and adjust path
    if string.find(bodyName, "MUN") or string.find(bodyName, "MINMUS") or
       string.find(bodyName, "LAYTHE") or string.find(bodyName, "VALL") or
       string.find(bodyName, "TYLO") or string.find(bodyName, "BOP") or
       string.find(bodyName, "POL") or string.find(bodyName, "IKE") then
        templatePath = "PlanetTemplate_" .. bodyName:sub(1,1) .. bodyName:sub(2):lower()
    elseif string.find(bodyName, "BELT") then
        templatePath = "PlanetTemplate_" .. bodyName
    else
        templatePath = "PlanetTemplate_" .. bodyName:sub(1,1) .. bodyName:sub(2):lower()
    end

    -- Load pre-existing model from Roblox Studio
    local template = game:GetService("ServerStorage"):WaitForChild("PlanetTemplates"):WaitForChild(templatePath):Clone()
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

    -- Verify model scale matches physics constants
    local size = template:GetExtentsSize()
    local expectedDiameter = PhysicsConstants[bodyName].RADIUS * 2
    local scaleDiff = math.abs(size.X - expectedDiameter) / expectedDiameter
    if scaleDiff > 0.1 then -- Allow 10% difference
        logDebug(bodyName, "Warning: Model size (%0.2f) differs from expected diameter (%0.2f)", 
            size.X, expectedDiameter)
    end

    -- Set position using optimized CFrame calculation
    local position = getRelativePosition(bodyName)
    template:SetPrimaryPartCFrame(position)
    logDebug(bodyName, "Positioned at (%.1f, %.1f, %.1f)", 
        position.X, position.Y, position.Z)

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