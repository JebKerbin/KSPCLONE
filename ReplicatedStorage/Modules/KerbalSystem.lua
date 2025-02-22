local KerbalSystem = {}

function KerbalSystem.new(name)
    local kerbal = {
        name = name,
        isEVA = false,
        currentPod = nil,
        experience = 0,
        level = 1,
        skills = {
            piloting = 1,
            science = 1,
            engineering = 1
        }
    }

    function kerbal:enterPod(pod)
        if not self.isEVA then return end
        if not pod then return end

        self.currentPod = pod
        self.isEVA = false
        -- Hide kerbal character
        -- Implement character hiding logic here
    end

    function kerbal:exitPod()
        if self.isEVA then return end
        if not self.currentPod then return end

        self.isEVA = true
        -- Show and position kerbal character
        -- Implement character showing logic here

        self.currentPod = nil
    end

    -- Add experience and level up system
    function kerbal:addExperience(amount, skillType)
        self.experience = self.experience + amount

        -- Update specific skill if provided
        if skillType and self.skills[skillType] then
            self.skills[skillType] = self.skills[skillType] + math.floor(amount / 100)
        end

        -- Level up system
        local newLevel = math.floor(self.experience / 1000) + 1
        if newLevel > self.level then
            self.level = newLevel
            -- Implement level up effects here
        end
    end

    -- Perform EVA experiment
    function kerbal:performExperiment(experimentType, spacecraft)
        if not self.isEVA then
            return false, "Kerbal must be on EVA to perform experiments"
        end

        -- Get current situation and celestial body
        local situation = "EVA"
        local nearestBody = spacecraft:getNearestCelestialBody()

        -- Start the experiment
        local scienceSystem = spacecraft.scienceSystem
        local success, message = scienceSystem:startExperiment(
            experimentType,
            situation,
            nearestBody
        )

        if success then
            -- Add experience for performing experiment
            self:addExperience(50, "science")
        end

        return success, message
    end

    return kerbal
end

local KerbalFactory = {
    createJebediah = function()
        local jeb = KerbalSystem.new("Jebediah Kerman")
        -- Add special traits for Jebediah
        jeb.skills.piloting = 3
        jeb.experience = 2000
        return jeb
    end,

    createBill = function()
        local bill = KerbalSystem.new("Bill Kerman")
        -- Add special traits for Bill
        bill.skills.engineering = 3
        bill.experience = 1500
        return bill
    end,

    createBob = function()
        local bob = KerbalSystem.new("Bob Kerman")
        -- Add special traits for Bob
        bob.skills.science = 3
        bob.experience = 1500
        return bob
    end
}

return KerbalFactory