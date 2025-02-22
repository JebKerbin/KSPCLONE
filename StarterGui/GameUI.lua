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
    fuelFrame.Size = UDim2.new(0, 200, 0, 20)
    fuelFrame.Position = UDim2.new(0, 10, 0, 130)
    fuelFrame.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)
    fuelFrame.Parent = mainFrame
    
    local fuelBar = Instance.new("Frame")
    fuelBar.Size = UDim2.new(1, 0, 1, 0)
    fuelBar.BackgroundColor3 = Color3.new(0, 1, 0)
    fuelBar.Parent = fuelFrame
    
    -- Create SAS indicator
    local sasIndicator = Instance.new("TextLabel")
    sasIndicator.Size = UDim2.new(0, 100, 0, 30)
    sasIndicator.Position = UDim2.new(0, 10, 0, 160)
    sasIndicator.Text = "SAS: OFF"
    sasIndicator.Parent = mainFrame
    
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
    
    mainFrame.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    
    return ui
end

return GameUI
