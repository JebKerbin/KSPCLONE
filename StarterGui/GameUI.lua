local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GameUI = {}

function GameUI.new()
    local ui = {}

    -- Create main UI frame
    local mainFrame = Instance.new("ScreenGui")
    mainFrame.Name = "KSPInterface"

    -- Create altitude display
    local altitudeFrame = Instance.new("Frame")
    altitudeFrame.Size = UDim2.new(0, 200, 0, 50)
    altitudeFrame.Position = UDim2.new(0, 10, 0, 10)
    altitudeFrame.BackgroundTransparency = 0.5
    altitudeFrame.Parent = mainFrame

    local altitudeText = Instance.new("TextLabel")
    altitudeText.Size = UDim2.new(1, 0, 1, 0)
    altitudeText.Text = "Altitude: 0m"
    altitudeText.Parent = altitudeFrame

    -- Create velocity display
    local velocityFrame = Instance.new("Frame")
    velocityFrame.Size = UDim2.new(0, 200, 0, 50)
    velocityFrame.Position = UDim2.new(0, 10, 0, 70)
    velocityFrame.BackgroundTransparency = 0.5
    velocityFrame.Parent = mainFrame

    local velocityText = Instance.new("TextLabel")
    velocityText.Size = UDim2.new(1, 0, 1, 0)
    velocityText.Text = "Velocity: 0m/s"
    velocityText.Parent = velocityFrame

    -- Create fuel gauge
    local fuelFrame = Instance.new("Frame")
    local fuelBar = Instance.new("Frame")
    fuelFrame.Size = UDim2.new(0, 200, 0, 20)
    fuelFrame.Position = UDim2.new(0, 10, 0, 130)
    fuelFrame.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)
    fuelFrame.Parent = mainFrame

    fuelBar.Size = UDim2.new(1, 0, 1, 0)
    fuelBar.BackgroundColor3 = Color3.new(0, 1, 0)
    fuelBar.Parent = fuelFrame

    -- Create SAS indicator
    local sasIndicator = Instance.new("TextLabel")
    sasIndicator.Size = UDim2.new(0, 100, 0, 30)
    sasIndicator.Position = UDim2.new(0, 10, 0, 160)
    sasIndicator.Text = "SAS: OFF"
    sasIndicator.Parent = mainFrame

    -- Create debug info panel
    local debugFrame = Instance.new("Frame")
    debugFrame.Size = UDim2.new(0, 300, 0, 200)
    debugFrame.Position = UDim2.new(1, -310, 0, 10)
    debugFrame.BackgroundTransparency = 0.5
    debugFrame.Parent = mainFrame

    local debugTitle = Instance.new("TextLabel")
    debugTitle.Size = UDim2.new(1, 0, 0, 30)
    debugTitle.Text = "Debug Information"
    debugTitle.Parent = debugFrame

    local debugText = Instance.new("TextLabel")
    debugText.Size = UDim2.new(1, 0, 1, -30)
    debugText.Position = UDim2.new(0, 0, 0, 30)
    debugText.Text = "Initializing..."
    debugText.TextXAlignment = Enum.TextXAlignment.Left
    debugText.TextYAlignment = Enum.TextYAlignment.Top
    debugText.Parent = debugFrame

    function ui:updateAltitude(altitude)
        altitudeText.Text = string.format("Altitude: %.1fm", altitude)
    end

    function ui:updateVelocity(velocity)
        velocityText.Text = string.format("Velocity: %.1fm/s", velocity)
    end

    function ui:updateFuel(current, max)
        fuelBar.Size = UDim2.new(current/max, 0, 1, 0)
    end

    function ui:updateSAS(enabled)
        sasIndicator.Text = "SAS: " .. (enabled and "ON" or "OFF")
    end

    function ui:updateDebug(spacecraft, celestialBodies, PhysicsConstants, PlanetTemplateGenerator)
        local text = "Spacecraft Info:\n"
        if spacecraft then
            local position = spacecraft.parts[1].Position
            text = text .. string.format("Position: %s\n", tostring(position))
            text = text .. string.format("Velocity: %s\n", tostring(spacecraft.parts[1].Velocity))
            text = text .. string.format("Fuel: %.1f/%.1f\n", spacecraft.fuel, spacecraft.maxFuel)

            -- Add distances to nearest celestial bodies
            text = text .. "\nNearest Bodies:\n"
            local distances = {}
            for name, body in pairs(celestialBodies) do
                if body and body.PrimaryPart then
                    local distance = (position - body.PrimaryPart.Position).Magnitude
                    table.insert(distances, {name = name, distance = distance})
                end
            end
            -- Sort by distance and show closest 5 bodies
            table.sort(distances, function(a, b) return a.distance < b.distance end)
            for i = 1, math.min(5, #distances) do
                text = text .. string.format("%s: %.1f studs\n", distances[i].name, distances[i].distance)
            end
        else
            text = text .. "No spacecraft found\n"
        end

        text = text .. "\nCelestial Bodies:\n"
        for name, body in pairs(celestialBodies or {}) do
            if body and body.PrimaryPart then
                text = text .. string.format("%s:\n", name)
                text = text .. string.format("  Position: %s\n", tostring(body.PrimaryPart.Position))
                text = text .. string.format("  Radius: %.1f studs\n", body.PrimaryPart.Size.X/2)

                -- Show atmosphere height if applicable
                if PhysicsConstants and PhysicsConstants[name] and PhysicsConstants[name].ATMOSPHERE_HEIGHT then
                    text = text .. string.format("  Atmosphere Height: %.1f studs\n", 
                        PhysicsConstants[name].ATMOSPHERE_HEIGHT)
                end

                -- Show surface gravity
                if PhysicsConstants and PhysicsConstants[name] and PhysicsConstants[name].SURFACE_GRAVITY then
                    text = text .. string.format("  Surface Gravity: %.2f m/s²\n", 
                        PhysicsConstants[name].SURFACE_GRAVITY)
                end

                -- For moons, show distance from parent body
                local parent = (PlanetTemplateGenerator and PlanetTemplateGenerator.PLANET_PROPERTIES[name] and PlanetTemplateGenerator.PLANET_PROPERTIES[name].PARENT) or nil
                if parent and celestialBodies[parent] then
                    local distanceFromParent = (body.PrimaryPart.Position - 
                        celestialBodies[parent].PrimaryPart.Position).Magnitude
                    text = text .. string.format("  Distance from %s: %.1f studs\n", 
                        parent, distanceFromParent)
                end
            end
        end

        debugText.Text = text
    end

    mainFrame.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

    return ui
end

return GameUI