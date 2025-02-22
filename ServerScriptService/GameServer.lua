local PhysicsService = game:GetService("PhysicsService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Stats = game:GetService("Stats")

-- Cache frequently used constructors
local Instance_new = Instance.new
local CFrame_new = CFrame.new
local Vector3_new = Vector3.new
local tick = tick

-- Load required modules
local OrbitalMechanics = require(game.ReplicatedStorage.Modules.OrbitalMechanics)
local PhysicsConstants = require(game.ReplicatedStorage.Modules.PhysicsConstants)
local SpacecraftSystem = require(game.ReplicatedStorage.Modules.SpacecraftSystem)
local PlanetTemplateGenerator = require(game.ReplicatedStorage.Assets.Planets.PlanetTemplateGenerator)

-- Initialize RemoteEvents with proper caching
local Events = {
    UpdateThrottle = Instance_new("RemoteEvent"),
    UpdateRotation = Instance_new("RemoteEvent"),
    ToggleSAS = Instance_new("RemoteEvent"),
    Stage = Instance_new("RemoteEvent"),
    SpacecraftUpdate = Instance_new("RemoteEvent"),
    CelestialBodyUpdate = Instance_new("RemoteEvent")
}

for name, event in pairs(Events) do
    event.Name = name
    event.Parent = ReplicatedStorage
end

-- GameServer with optimized systems
local GameServer = {
    celestialBodies = {},
    activeSpacecraft = {},
    spatialRegions = {},
    updateConnections = {},
    physicsStats = {
        lastUpdateTime = 0,
        updateCount = 0,
        averageUpdateTime = 0,
        peakUpdateTime = 0,
        frameTimeHistory = {},
        HISTORY_SIZE = 60 -- Store 1 minute of frame times at 60 FPS
    }
}

-- Enhanced spatial partitioning system
local function initializeSpatialRegions()
    local regions = {}
    local regionSize = 1000
    local gridSize = 10

    for x = -gridSize/2, gridSize/2 do
        for y = -gridSize/2, gridSize/2 do
            for z = -gridSize/2, gridSize/2 do
                local region = {
                    center = Vector3_new(x * regionSize, y * regionSize, z * regionSize),
                    size = Vector3_new(regionSize, regionSize, regionSize),
                    objects = {},
                    lastUpdate = 0
                }
                table.insert(regions, region)
            end
        end
    end

    return regions
end

-- Optimized spatial region updates using time-based checks
local function updateSpatialRegions(self)
    local currentTime = tick()

    -- Update regions every 0.1 seconds
    if currentTime - self.lastRegionUpdate < 0.1 then return end
    self.lastRegionUpdate = currentTime

    -- Clear current assignments
    for _, region in ipairs(self.spatialRegions) do
        region.objects = {}
    end

    -- Assign objects to regions using optimized distance checks
    for _, spacecraft in pairs(self.activeSpacecraft) do
        local pos = spacecraft.parts[1].Position
        for _, region in ipairs(self.spatialRegions) do
            local diff = pos - region.center
            if math.abs(diff.X) <= region.size.X/2 and
               math.abs(diff.Y) <= region.size.Y/2 and
               math.abs(diff.Z) <= region.size.Z/2 then
                table.insert(region.objects, spacecraft)
                break
            end
        end
    end
end

-- Optimized celestial body creation with object pooling
local function findCelestialBodies()
    local bodies = {}
    local planetFolder = Instance_new("Folder")
    planetFolder.Name = "CelestialBodies"
    planetFolder.Parent = workspace

    -- Create celestial bodies in batches for better performance
    local celestialBodies = {
        "KERBOL", "MOHO", "EVE", "GILLY", "KERBIN", "MUN", "MINMUS",
        "DUNA", "IKE", "DRES", "JOOL", "LAYTHE", "VALL", "TYLO",
        "BOP", "POL", "EELOO"
    }

    -- Process bodies in batches of 4
    local BATCH_SIZE = 4
    for i = 1, #celestialBodies, BATCH_SIZE do
        local batch = {}
        for j = i, math.min(i + BATCH_SIZE - 1, #celestialBodies) do
            local bodyName = celestialBodies[j]

            local thread = coroutine.create(function()
                local planet = PlanetTemplateGenerator.createTemplate(bodyName)
                planet.Name = bodyName
                planet.Parent = planetFolder
                bodies[bodyName] = planet

                -- Create optimized gravity field
                local gravityField = Instance_new("BodyForce")
                gravityField.Name = "GravityField"
                gravityField.Parent = planet
            end)
            table.insert(batch, thread)
        end

        -- Resume batch threads
        for _, thread in ipairs(batch) do
            coroutine.resume(thread)
        end

        -- Small delay between batches to prevent frame drops
        RunService.Heartbeat:Wait()
    end

    return bodies
end

function GameServer:Initialize()
    self.lastRegionUpdate = tick()
    self.spatialRegions = initializeSpatialRegions()
    self.celestialBodies = findCelestialBodies()

    -- Initialize event handlers with proper cleanup
    local function setupEventHandler(event, handler)
        local connection = event.OnServerEvent:Connect(handler)
        table.insert(self.updateConnections, connection)
        return connection
    end

    -- Set up optimized event handlers
    setupEventHandler(Events.UpdateThrottle, function(player, throttle)
        local spacecraft = self:GetPlayerSpacecraft(player)
        if spacecraft then
            spacecraft:applyThrust(throttle)
        end
    end)

    setupEventHandler(Events.UpdateRotation, function(player, rotation)
        local spacecraft = self:GetPlayerSpacecraft(player)
        if spacecraft then
            spacecraft:applyRotation(rotation)
        end
    end)

    setupEventHandler(Events.ToggleSAS, function(player)
        local spacecraft = self:GetPlayerSpacecraft(player)
        if spacecraft then
            spacecraft.sasEnabled = not spacecraft.sasEnabled
        end
    end)

    setupEventHandler(Events.Stage, function(player)
        local spacecraft = self:GetPlayerSpacecraft(player)
        if spacecraft then
            spacecraft:stage()
        end
    end)

    -- Start physics update loop with performance monitoring
    local physicsConnection = RunService.Heartbeat:Connect(function(dt)
        self:UpdatePhysics(dt)
    end)
    table.insert(self.updateConnections, physicsConnection)
end

function GameServer:UpdatePhysics(dt)
    local startTime = tick()

    -- Update spatial regions for efficient physics calculations
    updateSpatialRegions(self)

    -- Process physics in batches for better performance
    for _, region in ipairs(self.spatialRegions) do
        for _, spacecraft in ipairs(region.objects) do
            -- Calculate gravitational forces from nearby celestial bodies
            local totalForce = Vector3_new(0, 0, 0)

            for name, body in pairs(self.celestialBodies) do
                if body and body.PrimaryPart then
                    local force = OrbitalMechanics.calculateGravitationalForce(
                        PhysicsConstants[name].MASS,
                        spacecraft.mass,
                        body.PrimaryPart.Position,
                        spacecraft.parts[1].Position
                    )
                    totalForce = totalForce + force
                end
            end

            -- Apply forces efficiently
            local bodyForce = spacecraft.parts[1]:FindFirstChild("EngineForce")
            if bodyForce then
                bodyForce.Force = totalForce
            end
        end
    end

    -- Update performance metrics
    local updateTime = tick() - startTime
    table.insert(self.physicsStats.frameTimeHistory, updateTime)
    if #self.physicsStats.frameTimeHistory > self.physicsStats.HISTORY_SIZE then
        table.remove(self.physicsStats.frameTimeHistory, 1)
    end

    self.physicsStats.updateCount = self.physicsStats.updateCount + 1
    self.physicsStats.averageUpdateTime = (self.physicsStats.averageUpdateTime * (self.physicsStats.updateCount - 1) + updateTime) / self.physicsStats.updateCount
    self.physicsStats.peakUpdateTime = math.max(self.physicsStats.peakUpdateTime, updateTime)

    -- Log performance metrics periodically
    if tick() - self.physicsStats.lastUpdateTime > 60 then
        self:LogPerformanceMetrics()
        self.physicsStats.peakUpdateTime = 0
        self.physicsStats.lastUpdateTime = tick()
    end
end

function GameServer:LogPerformanceMetrics()
    -- Calculate additional metrics
    local sum = 0
    local min = math.huge
    local max = 0
    for _, time in ipairs(self.physicsStats.frameTimeHistory) do
        sum = sum + time
        min = math.min(min, time)
        max = math.max(max, time)
    end
    local avg = sum / #self.physicsStats.frameTimeHistory

    print(string.format("[GameServer] Performance Metrics:\n" ..
        "Average Update Time: %.6f seconds\n" ..
        "Min Update Time: %.6f seconds\n" ..
        "Max Update Time: %.6f seconds\n" ..
        "Updates per Second: %.2f\n" ..
        "Memory Usage: %.2f MB\n" ..
        "Active Spacecraft: %d",
        avg,
        min,
        max,
        1/avg,
        Stats.GetTotalMemoryUsageMb(),
        #self.activeSpacecraft))
end

function GameServer:RegisterSpacecraft(spacecraft, player)
    self.activeSpacecraft[player.UserId] = spacecraft

    -- Create optimized engine force
    local engineForce = Instance_new("BodyForce")
    engineForce.Name = "EngineForce"
    engineForce.Parent = spacecraft.parts[1]

    -- Set up cleanup when player leaves
    local connection = player.AncestryChanged:Connect(function(_, parent)
        if not parent then
            self:UnregisterSpacecraft(player)
        end
    end)
    table.insert(self.updateConnections, connection)
end

function GameServer:UnregisterSpacecraft(player)
    local spacecraft = self.activeSpacecraft[player.UserId]
    if spacecraft then
        spacecraft:cleanup()
    end
    self.activeSpacecraft[player.UserId] = nil
end

function GameServer:Cleanup()
    -- Disconnect all update connections
    for _, connection in ipairs(self.updateConnections) do
        connection:Disconnect()
    end
    self.updateConnections = {}

    -- Clean up spacecraft
    for userId, spacecraft in pairs(self.activeSpacecraft) do
        spacecraft:cleanup()
        self.activeSpacecraft[userId] = nil
    end

    -- Clean up celestial bodies
    for name, body in pairs(self.celestialBodies) do
        if body then
            body:Destroy()
        end
    end
    self.celestialBodies = {}

    -- Clear performance metrics
    self.physicsStats.frameTimeHistory = {}
end

-- Initialize the game server
local success, error = pcall(function()
    GameServer:Initialize()
end)

if not success then
    warn("[GameServer] Initialization failed:", error)
end

game:BindToClose(function()
    GameServer:Cleanup()
end)

return GameServer