local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerStats = {}

-- Create DataStore
local statsStore = DataStoreService:GetDataStore("KSPStats")

-- Default stats for new players
local DEFAULT_STATS = {
    money = 10000,
    reputation = 0,
    researchPoints = 0,
    missionsCompleted = 0,
    totalFlightTime = 0,
    unlockedParts = {
        "CommandPod",
        "FuelTank",
        "Engine",
        "Winglet"
    },
    achievements = {},
    careerStats = {
        totalExplosions = 0,
        kerbalsLost = 0,
        successfulLandings = 0,
        orbitsAchieved = 0,
        maxAltitude = 0
    }
}

-- Create RemoteEvents for stat updates
local Events = {
    UpdateMoney = Instance.new("RemoteEvent"),
    UpdateReputation = Instance.new("RemoteEvent"),
    UpdateResearch = Instance.new("RemoteEvent"),
    UnlockPart = Instance.new("RemoteEvent")
}

for name, event in pairs(Events) do
    event.Name = name
    event.Parent = ReplicatedStorage
end

function PlayerStats.new(player)
    local stats = {
        player = player,
        data = nil
    }

    -- Load player data
    function stats:load()
        local success, result = pcall(function()
            return statsStore:GetAsync(tostring(self.player.UserId)) or DEFAULT_STATS
        end)

        if success then
            self.data = result
            print(string.format("[PlayerStats] Loaded stats for %s", self.player.Name))
        else
            warn(string.format("[PlayerStats] Failed to load stats for %s: %s", self.player.Name, result))
            self.data = DEFAULT_STATS
        end
    end

    -- Save player data
    function stats:save()
        if not self.data then return end
        
        local success, result = pcall(function()
            statsStore:SetAsync(tostring(self.player.UserId), self.data)
        end)

        if success then
            print(string.format("[PlayerStats] Saved stats for %s", self.player.Name))
        else
            warn(string.format("[PlayerStats] Failed to save stats for %s: %s", self.player.Name, result))
        end
    end

    -- Update money
    function stats:updateMoney(amount)
        self.data.money = math.max(0, self.data.money + amount)
        Events.UpdateMoney:FireClient(self.player, self.data.money)
    end

    -- Update reputation
    function stats:updateReputation(amount)
        self.data.reputation = math.max(0, self.data.reputation + amount)
        Events.UpdateReputation:FireClient(self.player, self.data.reputation)
    end

    -- Update research points
    function stats:updateResearch(amount)
        self.data.researchPoints = math.max(0, self.data.researchPoints + amount)
        Events.UpdateResearch:FireClient(self.player, self.data.researchPoints)
    end

    -- Unlock a new part
    function stats:unlockPart(partName)
        if not table.find(self.data.unlockedParts, partName) then
            table.insert(self.data.unlockedParts, partName)
            Events.UnlockPart:FireClient(self.player, partName)
        end
    end

    -- Update career stats
    function stats:updateCareerStat(statName, value)
        if self.data.careerStats[statName] ~= nil then
            if statName == "maxAltitude" then
                self.data.careerStats[statName] = math.max(self.data.careerStats[statName], value)
            else
                self.data.careerStats[statName] = self.data.careerStats[statName] + value
            end
        end
    end

    -- Grant achievement
    function stats:grantAchievement(achievementId)
        if not self.data.achievements[achievementId] then
            self.data.achievements[achievementId] = true
            -- Reward player for achievement
            self:updateMoney(1000)
            self:updateReputation(50)
        end
    end

    -- Auto-save every 5 minutes
    spawn(function()
        while wait(300) do
            stats:save()
        end
    end)

    -- Load initial data
    stats:load()

    return stats
end

return PlayerStats
