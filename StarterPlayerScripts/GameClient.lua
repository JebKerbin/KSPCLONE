local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local SpacecraftSystem = require(game.ReplicatedStorage.Modules.SpacecraftSystem)
local GameUI = require(game.StarterGui.GameUI)

local GameClient = {}

function GameClient:Initialize()
    self.ui = GameUI.new()
    self.throttle = 0
    self.spacecraft = nil
    self.controls = {
        forward = false,
        backward = false,
        left = false,
        right = false,
        rollLeft = false,
        rollRight = false,
        sasEnabled = false
    }
    
    self:SetupInputHandling()
    self:SetupUpdateLoop()
end

function GameClient:SetupInputHandling()
    -- Keyboard controls
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.W then
            self.controls.forward = true
        elseif input.KeyCode == Enum.KeyCode.S then
            self.controls.backward = true
        elseif input.KeyCode == Enum.KeyCode.A then
            self.controls.left = true
        elseif input.KeyCode == Enum.KeyCode.D then
            self.controls.right = true
        elseif input.KeyCode == Enum.KeyCode.Q then
            self.controls.rollLeft = true
        elseif input.KeyCode == Enum.KeyCode.E then
            self.controls.rollRight = true
        elseif input.KeyCode == Enum.KeyCode.T then
            self.controls.sasEnabled = not self.controls.sasEnabled
            self:UpdateSAS()
        elseif input.KeyCode == Enum.KeyCode.Space then
            self:Stage()
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.W then
            self.controls.forward = false
        elseif input.KeyCode == Enum.KeyCode.S then
            self.controls.backward = false
        elseif input.KeyCode == Enum.KeyCode.A then
            self.controls.left = false
        elseif input.KeyCode == Enum.KeyCode.D then
            self.controls.right = false
        elseif input.KeyCode == Enum.KeyCode.Q then
            self.controls.rollLeft = false
        elseif input.KeyCode == Enum.KeyCode.E then
            self.controls.rollRight = false
        end
    end)
end

function GameClient:SetupUpdateLoop()
    RunService.RenderStepped:Connect(function(dt)
        if not self.spacecraft then return end
        
        -- Update throttle
        if self.controls.forward then
            self.throttle = math.min(1, self.throttle + dt)
        elseif self.controls.backward then
            self.throttle = math.max(0, self.throttle - dt)
        end
        
        -- Apply thrust
        local thrust = self.spacecraft:applyThrust(self.throttle)
        
        -- Update UI
        self:UpdateUI()
    end)
end

function GameClient:UpdateUI()
    if not self.spacecraft then return end
    
    local primaryPart = self.spacecraft.parts[1]
    local altitude = (primaryPart.Position - Vector3.new(0, 0, 0)).Magnitude
    local velocity = primaryPart.Velocity.Magnitude
    
    self.ui:updateAltitude(altitude)
    self.ui:updateVelocity(velocity)
    self.ui:updateFuel(self.spacecraft.fuel, self.spacecraft.maxFuel)
    self.ui:updateSAS(self.controls.sasEnabled)
end

function GameClient:UpdateSAS()
    if not self.spacecraft then return end
    
    -- Update SAS status
    self.spacecraft.sasEnabled = self.controls.sasEnabled
    self.ui:updateSAS(self.controls.sasEnabled)
end

function GameClient:Stage()
    if not self.spacecraft then return end
    
    self.spacecraft:stage()
end

return GameClient
