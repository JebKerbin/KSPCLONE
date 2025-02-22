local PhysicsConstants = require(game.ReplicatedStorage.Modules.PhysicsConstants)
local RunService = game:GetService("RunService")

local OrbitalMotion = {}

-- Cache math functions for performance
local cos = math.cos
local sin = math.sin
local pi = math.pi
local sqrt = math.sqrt

-- Calculate orbital position at a given time using CFrame for better performance
function OrbitalMotion.calculateOrbitalPosition(parentPosition, orbitRadius, period, time, inclination)
    -- Convert time to angle (in radians)
    local angle = (time % period) / period * 2 * pi

    -- Calculate base position in orbital plane
    local x = cos(angle) * orbitRadius
    local z = sin(angle) * orbitRadius

    -- Apply inclination rotation if specified
    if inclination then
        local y = z * sin(inclination)
        z = z * cos(inclination)
        -- Use CFrame for better rotation performance
        return CFrame.new(parentPosition) * CFrame.new(x, y, z)
    end

    return CFrame.new(parentPosition) * CFrame.new(x, 0, z)
end

-- Calculate orbital period based on semi-major axis and parent mass
function OrbitalMotion.calculateOrbitalPeriod(parentMass, semiMajorAxis)
    return 2 * pi * sqrt(semiMajorAxis * semiMajorAxis * semiMajorAxis / 
        (PhysicsConstants.G * parentMass))
end

-- Start orbiting a celestial body around its parent with optimized performance
function OrbitalMotion.startOrbiting(celestialBody, parentBody, orbitRadius, inclination)
    local period = OrbitalMotion.calculateOrbitalPeriod(
        PhysicsConstants[parentBody.Name].MASS,
        orbitRadius
    )

    -- Create a unique identifier for this connection
    local connectionName = celestialBody.Name .. "_OrbitConnection"

    -- Remove existing connection if present
    if celestialBody:GetAttribute(connectionName) then
        RunService:UnbindFromRenderStep(celestialBody:GetAttribute(connectionName))
    end

    -- Store start time for orbit calculation
    local startTime = tick()

    -- Create new connection with proper priority
    local connection = RunService:BindToRenderStep(
        connectionName,
        Enum.RenderPriority.Camera.Value - 1,
        function()
            local elapsedTime = tick() - startTime
            local newCFrame = OrbitalMotion.calculateOrbitalPosition(
                parentBody.PrimaryPart.Position,
                orbitRadius,
                period,
                elapsedTime,
                inclination
            )

            -- Update position of celestial body using CFrame
            celestialBody:SetPrimaryPartCFrame(newCFrame)
        end
    )

    -- Store connection identifier
    celestialBody:SetAttribute(connectionName, connectionName)

    -- Set up proper cleanup
    celestialBody.AncestryChanged:Connect(function(_, parent)
        if not parent then
            RunService:UnbindFromRenderStep(connectionName)
        end
    end)
end

return OrbitalMotion