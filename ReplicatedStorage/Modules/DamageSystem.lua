local PhysicsConstants = require(game.ReplicatedStorage.Modules.PhysicsConstants)
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local PhysicsService = game:GetService("PhysicsService")

-- Cache frequently used constructors
local Instance_new = Instance.new
local Vector3_new = Vector3.new
local CFrame_new = CFrame.new

local DamageSystem = {}

-- Damage types and their multipliers with optimized spread calculations
local DAMAGE_TYPES = {
    IMPACT = {
        multiplier = 1.0,
        spread = 0.5
    },
    HEAT = {
        multiplier = 0.8,
        spread = 0.3
    },
    STRESS = {
        multiplier = 0.6,
        spread = 0.7
    }
}

-- Pre-calculate common physics values
local DRAG_COEFFICIENT = 0.47 -- Approximate value for a sphere
local EXPLOSION_LIFETIME = 2
local DEBRIS_LIFETIME = 0.1

-- Optimized drag force calculation using CFrame
local function calculateDrag(part, velocity, atmosphereDensity)
    local crossSectionalArea = part.Size.X * part.Size.Y
    local dragForce = 0.5 * atmosphereDensity * velocity.Magnitude^2 * DRAG_COEFFICIENT * crossSectionalArea
    return -velocity.Unit * dragForce
end

function DamageSystem.new(spacecraft)
    local system = {
        parts = {},
        explosionQueue = {},
        spacecraft = spacecraft,
        -- Pre-configure collision group
        collisionGroup = "Spacecraft_" .. spacecraft.parts[1].Name,
        -- Cache OverlapParams for optimized spatial queries
        regionParams = OverlapParams.new()
    }

    -- Initialize collision group
    PhysicsService:CreateCollisionGroup(system.collisionGroup)
    system.regionParams.FilterType = Enum.RaycastFilterType.Whitelist
    system.regionParams.FilterDescendantsInstances = {spacecraft}

    -- Initialize health for all parts with pre-allocation
    for _, part in ipairs(spacecraft.parts) do
        system.parts[part] = {
            health = 100,
            maxHealth = 100,
            isExploding = false,
            damageMultiplier = 1.0,
            previousVelocity = Vector3_new(0, 0, 0)
        }
        -- Set collision group
        PhysicsService:SetPartCollisionGroup(part, system.collisionGroup)
    end

    -- Optimized damage application with spatial awareness
    function system:applyDamage(part, amount, damageType)
        if not self.parts[part] then return end

        local damage = amount * DAMAGE_TYPES[damageType].multiplier * self.parts[part].damageMultiplier
        self.parts[part].health = math.max(0, self.parts[part].health - damage)

        -- Use GetConnectedParts for optimized spreading
        if damage > 0 then
            local spreadAmount = damage * DAMAGE_TYPES[damageType].spread
            for _, connectedPart in ipairs(part:GetConnectedParts()) do
                if self.parts[connectedPart] then
                    self:applyDamage(connectedPart, spreadAmount, damageType)
                end
            end
        end

        -- Queue explosion if health depleted
        if self.parts[part].health <= 0 and not self.parts[part].isExploding then
            self:queueExplosion(part)
        end
    end

    -- Optimized explosion handling
    function system:queueExplosion(part)
        if not self.parts[part] then return end
        self.parts[part].isExploding = true
        table.insert(self.explosionQueue, part)
    end

    -- Process explosions with efficient region queries
    function system:processExplosions()
        while #self.explosionQueue > 0 do
            local part = table.remove(self.explosionQueue, 1)
            if part and part.Parent then
                -- Create and configure explosion
                local explosion = Instance_new("Explosion")
                explosion.Position = part.Position
                explosion.BlastRadius = part.Size.Magnitude
                explosion.BlastPressure = 500000

                -- Optimized spatial query
                local region = Region3.new(
                    part.Position - Vector3_new(explosion.BlastRadius, explosion.BlastRadius, explosion.BlastRadius),
                    part.Position + Vector3_new(explosion.BlastRadius, explosion.BlastRadius, explosion.BlastRadius)
                )

                -- Efficient part lookup
                for _, nearbyPart in ipairs(workspace:GetPartBoundsInBox(
                    CFrame_new(region.CFrame.Position),
                    region.Size,
                    self.regionParams
                )) do
                    if self.parts[nearbyPart] then
                        local distance = (nearbyPart.Position - part.Position).Magnitude
                        local damage = 100 * (1 - math.min(1, distance / explosion.BlastRadius))
                        self:applyDamage(nearbyPart, damage, "IMPACT")
                    end
                end

                -- Efficient cleanup
                explosion.Parent = workspace
                Debris:AddItem(explosion, EXPLOSION_LIFETIME)
                self.parts[part] = nil
                Debris:AddItem(part, DEBRIS_LIFETIME)
            end
        end
    end

    -- Optimized physics update with cached calculations
    function system:updatePhysics(dt)
        for part, data in pairs(self.parts) do
            if part.Parent then
                -- Calculate atmospheric effects
                local altitude = (part.Position - workspace.CelestialBodies.KERBIN.PrimaryPart.Position).Magnitude
                local atmosphereDensity = self:getAtmosphereDensity(altitude)

                -- Apply optimized drag force
                local dragForce = calculateDrag(part, part.Velocity, atmosphereDensity)
                local dragForceInstance = part:FindFirstChild("DragForce") or Instance_new("BodyForce")
                dragForceInstance.Name = "DragForce"
                dragForceInstance.Force = dragForce
                dragForceInstance.Parent = part

                -- Calculate stress with cached velocity
                local acceleration = (part.Velocity - data.previousVelocity) / dt
                local stressDamage = acceleration.Magnitude * 0.01

                if stressDamage > 1 then
                    self:applyDamage(part, stressDamage, "STRESS")
                end

                -- Update cached velocity
                data.previousVelocity = part.Velocity
            end
        end
    end

    -- Cached atmosphere density calculation
    local atmosphereDensityCache = {}
    function system:getAtmosphereDensity(altitude)
        -- Round altitude to nearest 100 for caching
        local roundedAltitude = math.floor(altitude / 100) * 100

        if not atmosphereDensityCache[roundedAltitude] then
            local kerbin = PhysicsConstants.KERBIN
            if altitude > kerbin.ATMOSPHERE_HEIGHT then
                atmosphereDensityCache[roundedAltitude] = 0
            else
                atmosphereDensityCache[roundedAltitude] = math.exp(-altitude / (kerbin.ATMOSPHERE_HEIGHT * 0.2))
            end
        end

        return atmosphereDensityCache[roundedAltitude]
    end

    -- Start update loop with optimized bindings
    local updateConnection = RunService.Heartbeat:Connect(function(dt)
        system:updatePhysics(dt)
        system:processExplosions()
    end)

    -- Set up proper cleanup
    spacecraft.parts[1].AncestryChanged:Connect(function(_, parent)
        if not parent then
            updateConnection:Disconnect()
            -- Clean up collision groups
            for part in pairs(self.parts) do
                pcall(function()
                    PhysicsService:SetPartCollisionGroup(part, "Default")
                end)
            end
            -- Clear caches
            atmosphereDensityCache = {}
        end
    end)

    return system
end

return DamageSystem