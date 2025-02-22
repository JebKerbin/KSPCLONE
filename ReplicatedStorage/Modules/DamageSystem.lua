local PhysicsConstants = require(game.ReplicatedStorage.Modules.PhysicsConstants)
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

local DamageSystem = {}

-- Damage types and their multipliers
local DAMAGE_TYPES = {
    IMPACT = {
        multiplier = 1.0,
        spread = 0.5 -- How much damage spreads to connected parts
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

-- Calculate drag force based on atmosphere density and velocity using CFrame
local function calculateDrag(part, velocity, atmosphereDensity)
    local dragCoefficient = 0.47 -- Approximate value for a sphere
    local crossSectionalArea = part.Size.X * part.Size.Y -- Simplified area calculation
    local dragForce = 0.5 * atmosphereDensity * velocity.Magnitude^2 * dragCoefficient * crossSectionalArea
    return -velocity.Unit * dragForce
end

function DamageSystem.new(spacecraft)
    local system = {
        parts = {},
        explosionQueue = {},
        spacecraft = spacecraft,
        regionParams = nil -- Will store OverlapParams for optimization
    }

    -- Initialize OverlapParams for optimized spatial queries
    system.regionParams = OverlapParams.new()
    system.regionParams.FilterType = Enum.RaycastFilterType.Whitelist
    system.regionParams.FilterDescendantsInstances = {spacecraft}

    -- Initialize health for all parts
    for _, part in ipairs(spacecraft.parts) do
        system.parts[part] = {
            health = 100,
            maxHealth = 100,
            isExploding = false,
            damageMultiplier = 1.0
        }
    end

    -- Apply damage to a part with optimized spreading
    function system:applyDamage(part, amount, damageType)
        if not self.parts[part] then return end

        local damage = amount * DAMAGE_TYPES[damageType].multiplier * self.parts[part].damageMultiplier
        self.parts[part].health = math.max(0, self.parts[part].health - damage)

        -- Use GetConnectedParts for optimized spreading
        local spreadAmount = damage * DAMAGE_TYPES[damageType].spread
        for _, connectedPart in ipairs(part:GetConnectedParts()) do
            if self.parts[connectedPart] then
                self:applyDamage(connectedPart, spreadAmount, damageType)
            end
        end

        -- Check for explosion
        if self.parts[part].health <= 0 and not self.parts[part].isExploding then
            self:queueExplosion(part)
        end
    end

    -- Queue part for explosion with proper cleanup
    function system:queueExplosion(part)
        if not self.parts[part] then return end
        self.parts[part].isExploding = true
        table.insert(self.explosionQueue, part)
    end

    -- Process explosion queue with optimized spatial queries
    function system:processExplosions()
        while #self.explosionQueue > 0 do
            local part = table.remove(self.explosionQueue, 1)
            if part and part.Parent then
                -- Create explosion effect
                local explosion = Instance.new("Explosion")
                explosion.Position = part.Position
                explosion.BlastRadius = part.Size.Magnitude
                explosion.BlastPressure = 500000

                -- Use Region3 for optimized spatial query
                local region = Region3.new(
                    part.Position - Vector3.new(explosion.BlastRadius, explosion.BlastRadius, explosion.BlastRadius),
                    part.Position + Vector3.new(explosion.BlastRadius, explosion.BlastRadius, explosion.BlastRadius)
                )

                -- Get parts in region using optimized query
                for _, nearbyPart in ipairs(workspace:GetPartBoundsInBox(region.CFrame, region.Size, self.regionParams)) do
                    if self.parts[nearbyPart] then
                        local distance = (nearbyPart.Position - part.Position).Magnitude
                        local damage = 100 * (1 - math.min(1, distance / explosion.BlastRadius))
                        self:applyDamage(nearbyPart, damage, "IMPACT")
                    end
                end

                -- Add explosion to debris system for automatic cleanup
                explosion.Parent = workspace
                Debris:AddItem(explosion, 2)

                -- Remove the part with proper cleanup
                self.parts[part] = nil
                Debris:AddItem(part, 0.1)
            end
        end
    end

    -- Update physics with optimized calculations
    function system:updatePhysics(dt)
        for part, data in pairs(self.parts) do
            if part.Parent then
                -- Calculate atmospheric drag using CFrame
                local altitude = (part.Position - workspace.CelestialBodies.KERBIN.PrimaryPart.Position).Magnitude
                local atmosphereDensity = self:getAtmosphereDensity(altitude)
                local dragForce = calculateDrag(part, part.Velocity, atmosphereDensity)

                -- Apply drag force with cached instance
                local dragForceInstance = part:FindFirstChild("DragForce") or Instance.new("BodyForce")
                dragForceInstance.Name = "DragForce"
                dragForceInstance.Force = dragForce
                dragForceInstance.Parent = part

                -- Calculate stress from acceleration using CFrame
                local previousVelocity = part:GetAttribute("PreviousVelocity") and Vector3.new(
                    part:GetAttribute("PreviousVelocityX"),
                    part:GetAttribute("PreviousVelocityY"),
                    part:GetAttribute("PreviousVelocityZ")
                ) or Vector3.new(0,0,0)

                local acceleration = (part.Velocity - previousVelocity) / dt
                local stressDamage = acceleration.Magnitude * 0.01
                if stressDamage > 1 then
                    self:applyDamage(part, stressDamage, "STRESS")
                end

                -- Store velocity components as attributes for better performance
                part:SetAttribute("PreviousVelocityX", part.Velocity.X)
                part:SetAttribute("PreviousVelocityY", part.Velocity.Y)
                part:SetAttribute("PreviousVelocityZ", part.Velocity.Z)
            end
        end
    end

    -- Get atmosphere density with cached calculations
    function system:getAtmosphereDensity(altitude)
        local kerbin = PhysicsConstants.KERBIN
        if altitude > kerbin.ATMOSPHERE_HEIGHT then return 0 end
        return math.exp(-altitude / (kerbin.ATMOSPHERE_HEIGHT * 0.2))
    end

    -- Start update loop with proper RunService binding
    local updateConnection = RunService.Heartbeat:Connect(function(dt)
        system:updatePhysics(dt)
        system:processExplosions()
    end)

    -- Set up proper cleanup
    spacecraft.parts[1].AncestryChanged:Connect(function(_, parent)
        if not parent then
            updateConnection:Disconnect()
        end
    end)

    return system
end

return DamageSystem