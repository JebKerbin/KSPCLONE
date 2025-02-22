local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerStats = require(game.ReplicatedStorage.Modules.PlayerStats)

local ScienceSystem = {}

-- Define experiment types and their base values
local EXPERIMENTS = {
    SURFACE_SAMPLE = {
        name = "Surface Sample",
        baseValue = 15,
        description = "Collect and analyze surface material"
    },
    TEMPERATURE_SCAN = {
        name = "Temperature Reading",
        baseValue = 10,
        description = "Measure atmospheric or surface temperature"
    },
    GRAVITY_SCAN = {
        name = "Gravity Scan",
        baseValue = 20,
        description = "Measure local gravitational forces"
    },
    ATMOSPHERIC_ANALYSIS = {
        name = "Atmospheric Analysis",
        baseValue = 25,
        description = "Analyze atmospheric composition"
    }
}

-- Multipliers for different situations
local SITUATION_MULTIPLIERS = {
    LANDED = 1.5,
    FLYING_LOW = 1.2,
    FLYING_HIGH = 1.0,
    SPACE_LOW = 2.0,
    SPACE_HIGH = 1.8,
    EVA = 1.3
}

-- Multipliers for different celestial bodies
local BODY_MULTIPLIERS = {
    KERBIN = 1.0,
    MUN = 2.0,
    MINMUS = 2.5,
    DUNA = 3.0,
    EVE = 3.5,
    MOHO = 4.0,
    JOOL = 4.5,
    EELOO = 5.0
}

function ScienceSystem.new(player)
    local system = {
        player = player,
        stats = PlayerStats.new(player),
        experiments = {},
        activeExperiments = {}
    }

    -- Create RemoteEvents for science interactions
    local Events = {
        StartExperiment = Instance.new("RemoteEvent"),
        CollectData = Instance.new("RemoteEvent"),
        TransmitData = Instance.new("RemoteEvent")
    }

    for name, event in pairs(Events) do
        event.Name = "Science_" .. name
        event.Parent = ReplicatedStorage
    end

    function system:canPerformExperiment(experimentType, situation, celestialBody)
        -- Check if experiment was already performed in this situation
        local experimentKey = string.format("%s_%s_%s", experimentType, situation, celestialBody)
        if self.experiments[experimentKey] then
            return false
        end
        return true
    end

    function system:calculateScienceValue(experimentType, situation, celestialBody)
        local baseValue = EXPERIMENTS[experimentType].baseValue
        local situationMultiplier = SITUATION_MULTIPLIERS[situation] or 1.0
        local bodyMultiplier = BODY_MULTIPLIERS[celestialBody] or 1.0
        
        return math.floor(baseValue * situationMultiplier * bodyMultiplier)
    end

    function system:startExperiment(experimentType, situation, celestialBody)
        if not self:canPerformExperiment(experimentType, situation, celestialBody) then
            return false, "Experiment already performed in this situation"
        end

        local experimentKey = string.format("%s_%s_%s", experimentType, situation, celestialBody)
        self.activeExperiments[experimentKey] = {
            type = experimentType,
            situation = situation,
            celestialBody = celestialBody,
            startTime = tick()
        }

        return true, "Experiment started"
    end

    function system:collectData(experimentKey)
        local experiment = self.activeExperiments[experimentKey]
        if not experiment then
            return false, "No active experiment found"
        end

        local scienceValue = self:calculateScienceValue(
            experiment.type,
            experiment.situation,
            experiment.celestialBody
        )

        -- Mark experiment as completed
        self.experiments[experimentKey] = {
            completed = true,
            value = scienceValue,
            timestamp = tick()
        }

        -- Remove from active experiments
        self.activeExperiments[experimentKey] = nil

        -- Update player stats
        self.stats:updateResearch(scienceValue)

        return true, string.format("Collected %d science points", scienceValue)
    end

    -- Set up event handlers
    Events.StartExperiment.OnServerEvent:Connect(function(player, experimentType, situation, celestialBody)
        if player ~= self.player then return end
        return self:startExperiment(experimentType, situation, celestialBody)
    end)

    Events.CollectData.OnServerEvent:Connect(function(player, experimentKey)
        if player ~= self.player then return end
        return self:collectData(experimentKey)
    end)

    Events.TransmitData.OnServerEvent:Connect(function(player, experimentKey)
        if player ~= self.player then return end
        local success, result = self:collectData(experimentKey)
        if success then
            -- Transmitting data gives less science (75% of normal value)
            self.stats:updateResearch(-math.floor(self.experiments[experimentKey].value * 0.25))
        end
        return success, result
    end)

    return system
end

return ScienceSystem
