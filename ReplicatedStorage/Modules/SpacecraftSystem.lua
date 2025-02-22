local PhysicsConstants = require(game.ReplicatedStorage.Modules.PhysicsConstants)

local SpacecraftSystem = {}

function SpacecraftSystem.new(commandPod)
    local spacecraft = {
        parts = {},
        fuel = 0,
        maxFuel = 0,
        thrust = 0,
        mass = 0,
        sasEnabled = false
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
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = self.parts[1]
        weld.Part1 = part
        weld.Parent = part
    end

    function spacecraft:applyThrust(throttle)
        if self.fuel <= 0 then return end

        local thrustForce = self.thrust * throttle
        local fuelConsumption = thrustForce / (PhysicsConstants.PARTS.ENGINE.ISP * 9.81)
        self.fuel = math.max(0, self.fuel - fuelConsumption)

        -- Apply thrust force in the direction the spacecraft is facing
        local thrustDirection = self.parts[1].CFrame.LookVector
        return thrustDirection * thrustForce
    end

    function spacecraft:applyRotation(direction)
        local primaryPart = self.parts[1]
        local torque = Instance.new("BodyAngularVelocity")
        torque.Name = "RotationTorque"
        torque.MaxTorque = Vector3.new(1000, 1000, 1000)

        if direction == "left" then
            torque.AngularVelocity = Vector3.new(0, 1, 0)
        elseif direction == "right" then
            torque.AngularVelocity = Vector3.new(0, -1, 0)
        elseif direction == "rollLeft" then
            torque.AngularVelocity = Vector3.new(0, 0, 1)
        elseif direction == "rollRight" then
            torque.AngularVelocity = Vector3.new(0, 0, -1)
        else
            torque.AngularVelocity = Vector3.new(0, 0, 0)
        end

        -- Remove any existing torque
        local existingTorque = primaryPart:FindFirstChild("RotationTorque")
        if existingTorque then
            existingTorque:Destroy()
        end

        torque.Parent = primaryPart
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
                -- Add explosion effect
                local explosion = Instance.new("Explosion")
                explosion.Position = part.Position
                explosion.Parent = game.Workspace
                -- Destroy part
                part:Destroy()
                break
            end
        end
    end

    -- Initialize with command pod
    spacecraft:addPart(commandPod)

    return spacecraft
end

return SpacecraftSystem