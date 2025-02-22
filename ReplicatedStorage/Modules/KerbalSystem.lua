local KerbalSystem = {}

function KerbalSystem.new(name)
    local kerbal = {
        name = name,
        isEVA = false,
        currentPod = nil
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
    
    return kerbal
end

local KerbalFactory = {
    createJebediah = function()
        return KerbalSystem.new("Jebediah Kerman")
    end,
    
    createBill = function()
        return KerbalSystem.new("Bill Kerman")
    end,
    
    createBob = function()
        return KerbalSystem.new("Bob Kerman")
    end
}

return KerbalFactory
