local PhysicsConstants = require(game.ReplicatedStorage.Modules.PhysicsConstants)
local DamageSystem = require(game.ReplicatedStorage.Modules.DamageSystem)
local RunService = game:GetService("RunService")

-- Cache frequently used functions
local Vector3_new = Vector3.new
local CFrame_new = CFrame.new
local Instance_new = Instance.new
local PhysicsService = game:GetService("PhysicsService")

local SpacecraftSystem = {}

function SpacecraftSystem.new(commandPod)
    local spacecraft = {
        parts = {},
        fuel = 0,
        maxFuel = 0,
        thrust = 0,
        mass = 0,
        sasEnabled = false,
        damage = nil, -- Will be initialized with DamageSystem
        stats = nil, -- Will be set by GameServer
        orbitalElements = nil, -- Store current orbital elements
        nearestBodyCache = {
            body = nil,
            lastUpdate = 0,
            updateInterval = 1 -- Update every second
        }
    }

    function spacecraft:addPart(part)
        table.insert(self.parts, part)

        -- Update spacecraft properties
        if part.Name == "FuelTank" then
            self.maxFuel = self.maxFuel + PhysicsConstants.PARTS.FUEL_TANK.FUEL_CAPACITY
            self.fuel = self.maxFuel
            self.mass = self.mass + PhysicsConstants.PARTS.FUEL_TANK.MASS
        elseif part.Name == "Engine" then
            self.thrust = self.thrust + PhysicsConstants.PARTS.ENGINE.THRUST
            self.mass = self.mass + PhysicsConstants.PARTS.ENGINE.MASS
        end

        -- Create weld constraint
        local weld = Instance_new("WeldConstraint")
        weld.Part0 = self.parts[1]
        weld.Part1 = part
        weld.Parent = part

        -- Update damage system
        if self.damage then
            self.damage.parts[part] = {
                health = 100,
                maxHealth = 100,
                isExploding = false,
                damageMultiplier = 1.0
            }
        end
    end

    function spacecraft:applyThrust(throttle)
        if self.fuel <= 0 then return end

        local thrustForce = self.thrust * throttle
        local fuelConsumption = thrustForce / (PhysicsConstants.PARTS.ENGINE.ISP * 9.81)
        self.fuel = math.max(0, self.fuel - fuelConsumption)

        -- Calculate thrust vector using CFrame for better performance
        local thrustDirection = self.parts[1].CFrame.LookVector

        -- Check for engine damage with cached values
        local enginePart = self.parts[#self.parts]
        local engineHealth = self.damage.parts[enginePart].health
        thrustForce = thrustForce * (engineHealth / 100)

        -- Update orbital elements after thrust
        if thrustForce > 0 then
            self:updateOrbitalElements()
        end

        return thrustDirection * thrustForce
    end

    function spacecraft:applyRotation(direction)
        if not self.sasEnabled then
            local primaryPart = self.parts[1]
            local torque = Instance_new("BodyAngularVelocity")
            torque.Name = "RotationTorque"
            torque.MaxTorque = Vector3_new(1000, 1000, 1000)

            if direction == "left" then
                torque.AngularVelocity = Vector3_new(0, 1, 0)
            elseif direction == "right" then
                torque.AngularVelocity = Vector3_new(0, -1, 0)
            elseif direction == "rollLeft" then
                torque.AngularVelocity = Vector3_new(0, 0, 1)
            elseif direction == "rollRight" then
                torque.AngularVelocity = Vector3_new(0, 0, -1)
            else
                torque.AngularVelocity = Vector3_new(0, 0, 0)
            end

            -- Remove any existing torque
            local existingTorque = primaryPart:FindFirstChild("RotationTorque")
            if existingTorque then
                existingTorque:Destroy()
            end

            torque.Parent = primaryPart
        end
    end

    function spacecraft:stage()
        -- Implementation for staging system
        for i = #self.parts, 1, -1 do
            local part = self.parts[i]
            if part.Name == "Engine" or part.Name == "FuelTank" then
                -- Remove welds
                for _, weld in ipairs(part:GetChildren()) do
                    if weld:IsA("WeldConstraint") then
                        weld:Destroy()
                    end
                end
                -- Remove part from spacecraft
                table.remove(self.parts, i)
                -- Add explosion effect and damage
                self.damage:queueExplosion(part)
                -- Update stats
                if self.stats then
                    self.stats:updateCareerStat("totalExplosions", 1)
                end
                break
            end
        end
    end

    function spacecraft:getNearestCelestialBody()
        -- Check cache first
        local currentTime = tick()
        if self.nearestBodyCache.body and 
           (currentTime - self.nearestBodyCache.lastUpdate) < self.nearestBodyCache.updateInterval then
            return self.nearestBodyCache.body
        end

        -- Find nearest body
        local primaryPart = self.parts[1]
        if not primaryPart then return nil end

        local nearestBody = nil
        local minDistance = math.huge

        -- Get celestial bodies folder
        local celestialBodies = workspace:FindFirstChild("CelestialBodies")
        if not celestialBodies then return nil end

        -- Find nearest body using optimized distance calculations
        for _, body in ipairs(celestialBodies:GetChildren()) do
            if body:IsA("Model") and body.PrimaryPart then
                local distance = (primaryPart.Position - body.PrimaryPart.Position).Magnitude

                -- Check if this body is closer than current nearest
                if distance < minDistance then
                    -- Only consider bodies within their gravity range
                    local gravityRange = PhysicsConstants[body.Name] and 
                                       PhysicsConstants[body.Name].GRAVITY_RANGE or 0

                    if distance <= gravityRange then
                        minDistance = distance
                        nearestBody = body
                    end
                end
            end
        end

        -- Update cache
        self.nearestBodyCache.body = nearestBody
        self.nearestBodyCache.lastUpdate = currentTime

        return nearestBody
    end

    function spacecraft:updateOrbitalElements()
        local primaryPart = self.parts[1]
        local nearestBody = self:getNearestCelestialBody()

        if primaryPart and nearestBody then
            self.orbitalElements = OrbitalMechanics.cartesianToOrbitalElements(
                primaryPart.Position,
                primaryPart.Velocity,
                PhysicsConstants[nearestBody.Name]
            )
        end
    end

    function spacecraft:setupCollisionHandling()
        -- Create collision group for optimization
        local collisionGroup = PhysicsService:CreateCollisionGroup("Spacecraft")

        for _, part in ipairs(self.parts) do
            -- Set collision group
            PhysicsService:SetPartCollisionGroup(part, "Spacecraft")

            -- Optimize collision detection with cached values
            local connection = part.Touched:Connect(function(hit)
                -- Skip if hit part is part of the same spacecraft
                if table.find(self.parts, hit) then return end

                local relativeVelocity = part.Velocity - (hit.Velocity or Vector3_new(0,0,0))
                local impactForce = relativeVelocity.Magnitude * part.Mass

                if impactForce > 100 then -- Threshold for damage
                    self.damage:applyDamage(part, impactForce * 0.1, "IMPACT")

                    -- Update stats if available
                    if self.stats then
                        self.stats:updateCareerStat("totalExplosions", 1)
                    end
                end
            end)

            -- Store connection for cleanup
            if not self.connections then self.connections = {} end
            table.insert(self.connections, connection)
        end
    end

    function spacecraft:cleanup()
        -- Disconnect all connections
        if self.connections then
            for _, connection in ipairs(self.connections) do
                connection:Disconnect()
            end
            self.connections = {}
        end

        -- Clear cache
        self.nearestBodyCache = {
            body = nil,
            lastUpdate = 0,
            updateInterval = 1
        }

        -- Clean up physics groups
        for _, part in ipairs(self.parts) do
            pcall(function()
                PhysicsService:SetPartCollisionGroup(part, "Default")
            end)
        end
    end

    -- Initialize spacecraft
    spacecraft:addPart(commandPod)
    spacecraft.damage = DamageSystem.new(spacecraft)
    spacecraft:setupCollisionHandling()

    -- Set up cleanup on part removal
    commandPod.AncestryChanged:Connect(function(_, parent)
        if not parent then
            spacecraft:cleanup()
        end
    end)

    return spacecraft
end

return SpacecraftSystem