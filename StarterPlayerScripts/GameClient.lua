local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SpacecraftSystem = require(game.ReplicatedStorage.Modules.SpacecraftSystem)
local GameUI = require(game.StarterGui.GameUI)
local PhysicsConstants = require(game.ReplicatedStorage.Modules.PhysicsConstants)
local PlanetTemplateGenerator = require(game.ReplicatedStorage.Assets.Planets.PlanetTemplateGenerator)

print("[GameClient] Starting initialization...")

-- Get RemoteEvents
local Events = {
    UpdateThrottle = ReplicatedStorage:WaitForChild("UpdateThrottle"),
    UpdateRotation = ReplicatedStorage:WaitForChild("UpdateRotation"),
    ToggleSAS = ReplicatedStorage:WaitForChild("ToggleSAS"),
    Stage = ReplicatedStorage:WaitForChild("Stage"),
    SpacecraftUpdate = ReplicatedStorage:WaitForChild("SpacecraftUpdate"),
    CelestialBodyUpdate = ReplicatedStorage:WaitForChild("CelestialBodyUpdate")
}

print("[GameClient] Found all RemoteEvents")

local _GameClient = {
    ui = nil,
    throttle = 0,
    spacecraft = nil,
    celestialBodies = nil,
    controls = {
        forward = false,
        backward = false,
        left = false,
        right = false,
        rollLeft = false,
        rollRight = false,
        sasEnabled = false
    }
}

function _GameClient:Initialize()
    print("[GameClient] Initializing client systems")
    self.ui = GameUI.new()
    self.celestialBodies = workspace:WaitForChild("CelestialBodies")
    print("[GameClient] Found CelestialBodies folder")

    -- Set up spacecraft update handler
    Events.SpacecraftUpdate.OnClientEvent:Connect(function(spacecraftData)
        print("[GameClient] Received spacecraft update")
        self.spacecraft = spacecraftData
        self:UpdateUI()
    end)

    -- Set up celestial body update handler
    Events.CelestialBodyUpdate.OnClientEvent:Connect(function(celestialBodyData)
        print("[GameClient] Received celestial body update")
        self:UpdateUI()
    end)

    self:SetupInputHandling()
    self:SetupUpdateLoop()
    print("[GameClient] Initialization complete")
end

function _GameClient:SetupInputHandling()
    print("[GameClient] Setting up input handling")
    -- Keyboard controls
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end

        if input.KeyCode == Enum.KeyCode.W then
            print("[GameClient] W key pressed - Throttle up")
            self.controls.forward = true
            self:UpdateThrottle(1)
        elseif input.KeyCode == Enum.KeyCode.S then
            print("[GameClient] S key pressed - Throttle down")
            self.controls.backward = true
            self:UpdateThrottle(-1)
        elseif input.KeyCode == Enum.KeyCode.A then
            print("[GameClient] A key pressed - Yaw left")
            self.controls.left = true
            self:UpdateRotation("left")
        elseif input.KeyCode == Enum.KeyCode.D then
            print("[GameClient] D key pressed - Yaw right")
            self.controls.right = true
            self:UpdateRotation("right")
        elseif input.KeyCode == Enum.KeyCode.Q then
            print("[GameClient] Q key pressed - Roll left")
            self.controls.rollLeft = true
            self:UpdateRotation("rollLeft")
        elseif input.KeyCode == Enum.KeyCode.E then
            print("[GameClient] E key pressed - Roll right")
            self.controls.rollRight = true
            self:UpdateRotation("rollRight")
        elseif input.KeyCode == Enum.KeyCode.T then
            print("[GameClient] T key pressed - Toggle SAS")
            self.controls.sasEnabled = not self.controls.sasEnabled
            Events.ToggleSAS:FireServer()
            self:UpdateSAS()
        elseif input.KeyCode == Enum.KeyCode.Space then
            print("[GameClient] Space key pressed - Stage")
            Events.Stage:FireServer()
        end
    end)

    UserInputService.InputEnded:Connect(function(input, gameProcessed)
        if gameProcessed then return end

        if input.KeyCode == Enum.KeyCode.W then
            print("[GameClient] W key released")
            self.controls.forward = false
            self:UpdateThrottle(0)
        elseif input.KeyCode == Enum.KeyCode.S then
            print("[GameClient] S key released")
            self.controls.backward = false
            self:UpdateThrottle(0)
        elseif input.KeyCode == Enum.KeyCode.A then
            print("[GameClient] A key released")
            self.controls.left = false
            self:UpdateRotation("none")
        elseif input.KeyCode == Enum.KeyCode.D then
            print("[GameClient] D key released")
            self.controls.right = false
            self:UpdateRotation("none")
        elseif input.KeyCode == Enum.KeyCode.Q then
            print("[GameClient] Q key released")
            self.controls.rollLeft = false
            self:UpdateRotation("none")
        elseif input.KeyCode == Enum.KeyCode.E then
            print("[GameClient] E key released")
            self.controls.rollRight = false
            self:UpdateRotation("none")
        end
    end)
end

function _GameClient:UpdateThrottle(direction)
    if direction == 1 then
        self.throttle = math.min(1, self.throttle + 0.1)
    elseif direction == -1 then
        self.throttle = math.max(0, self.throttle - 0.1)
    else
        self.throttle = 0
    end
    print(string.format("[GameClient] Updating throttle to: %.2f", self.throttle))
    Events.UpdateThrottle:FireServer(self.throttle)
end

function _GameClient:UpdateRotation(direction)
    print(string.format("[GameClient] Sending rotation update: %s", direction))
    Events.UpdateRotation:FireServer(direction)
end

function _GameClient:SetupUpdateLoop()
    RunService.RenderStepped:Connect(function(dt)
        self:UpdateUI()
    end)
end

function _GameClient:UpdateUI()
    if not self.spacecraft then return end

    local primaryPart = self.spacecraft.parts[1]
    if not primaryPart then return end

    local kerbinPart = workspace.CelestialBodies:FindFirstChild("KERBIN")
    if not kerbinPart or not kerbinPart.PrimaryPart then return end

    local altitude = (primaryPart.Position - kerbinPart.PrimaryPart.Position).Magnitude
    local velocity = primaryPart.Velocity.Magnitude

    self.ui:updateAltitude(altitude)
    self.ui:updateVelocity(velocity)
    self.ui:updateFuel(self.spacecraft.fuel, self.spacecraft.maxFuel)
    self.ui:updateSAS(self.controls.sasEnabled)

    -- Update debug information
    local celestialBodies = {}
    for _, body in ipairs(self.celestialBodies:GetChildren()) do
        if body:IsA("Model") and body.PrimaryPart then
            celestialBodies[body.Name] = body
        end
    end

    self.ui:updateDebug(
        self.spacecraft, 
        celestialBodies,
        PhysicsConstants,
        PlanetTemplateGenerator
    )
end

function _GameClient:UpdateSAS()
    if not self.spacecraft then return end
    print(string.format("[GameClient] Updating SAS status: %s", 
        self.controls.sasEnabled and "ON" or "OFF"))
    self.ui:updateSAS(self.controls.sasEnabled)
end

-- Initialize the game client immediately
print("[GameClient] Starting client initialization...")
_GameClient:Initialize()
print("[GameClient] Client initialization completed")