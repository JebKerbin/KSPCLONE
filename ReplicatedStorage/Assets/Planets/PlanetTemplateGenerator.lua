local PhysicsConstants = require(game.ReplicatedStorage.Modules.PhysicsConstants)
local OrbitalMotion = require(game.ReplicatedStorage.Modules.OrbitalMotion)
local RunService = game:GetService("RunService")

-- Debug logging function
local function logDebug(bodyName, message, ...)
    print(string.format("[PlanetTemplateGenerator][%s] %s", bodyName, message:format(...)))
end

-- Calculate relative position for celestial bodies
local function getRelativePosition(bodyName)
    if bodyName == "KERBOL" then
        return CFrame.new(0, 0, 0)
    end

    local parentName = PhysicsConstants[bodyName].PARENT or "KERBOL"
    local orbitRadius = PhysicsConstants[bodyName].ORBIT_RADIUS

    -- Create spiral pattern for orbit positions
    local angle = 0
    if parentName == "KERBOL" then
        local planets = {"MOHO", "EVE", "KERBIN", "DUNA", "DRES", "JOOL", "EELOO"}
        local index = table.find(planets, bodyName) or 1
        angle = index * (math.pi / 4)
    end

    return CFrame.new(
        math.cos(angle) * orbitRadius,
        math.sin(angle) * orbitRadius,
        0
    )
end

local PlanetTemplateGenerator = {}

function PlanetTemplateGenerator.createTemplate(bodyName)
    if not bodyName:match("^[A-Z]+$") then
        warn(string.format("[PlanetTemplateGenerator] Invalid body name format: %s", bodyName))
        return nil
    end

    -- Determine template folder based on whether it's a moon or planet
    local templateFolder = PhysicsConstants[bodyName].PARENT and "Moons" or "Planets"
    local templateName = "PlanetTemplate_" .. bodyName:sub(1,1) .. bodyName:sub(2):lower()

    -- Try to load pre-built model from appropriate folder
    local celestialTemplates = game:GetService("ServerStorage"):WaitForChild("CelestialTemplates")
    local template = celestialTemplates:WaitForChild(templateFolder):WaitForChild(templateName)

    if not template then
        warn(string.format("[PlanetTemplateGenerator] Could not find template for %s in %s folder", bodyName, templateFolder))
        return nil
    end

    template = template:Clone()
    template.Name = bodyName

    -- Verify PrimaryPart exists
    if not template.PrimaryPart then
        warn(string.format("[PlanetTemplateGenerator] Template %s missing PrimaryPart", bodyName))
        return nil
    end

    -- Set position using relative position calculation
    local position = getRelativePosition(bodyName)
    template:SetPrimaryPartCFrame(position)
    logDebug(bodyName, "Positioned at (%.1f, %.1f, %.1f)", 
        position.X, position.Y, position.Z)

    -- Store parent body as attribute for orbital mechanics
    if PhysicsConstants[bodyName].PARENT then
        template:SetAttribute("ParentBody", PhysicsConstants[bodyName].PARENT)
    end

    -- Clean up orbit connection when template is removed
    template.AncestryChanged:Connect(function(_, parent)
        if not parent then
            local orbitConnection = template:GetAttribute(bodyName .. "_OrbitConnection")
            if orbitConnection then
                RunService:UnbindFromRenderStep(orbitConnection)
                logDebug(bodyName, "Cleaned up orbit connection")
            end
        end
    end)

    return template
end

-- Start orbital motion for all moons around their parent bodies
function PlanetTemplateGenerator.startOrbits(celestialBodies)
    for bodyName, body in pairs(celestialBodies) do
        local parentName = body:GetAttribute("ParentBody")
        if parentName and celestialBodies[parentName] then
            local parentBody = celestialBodies[parentName]
            local orbitRadius = PhysicsConstants[bodyName].ORBIT_RADIUS

            -- Add inclination for specific bodies
            local inclination = nil
            if bodyName == "MINMUS" then
                inclination = math.rad(6)
            end

            OrbitalMotion.startOrbiting(body, parentBody, orbitRadius, inclination)
            logDebug(bodyName, "Started orbiting around %s at radius %.1f with inclination %s",
                parentName, orbitRadius, inclination and string.format("%.1f°", math.deg(inclination)) or "none")
        end
    end
end

return PlanetTemplateGenerator