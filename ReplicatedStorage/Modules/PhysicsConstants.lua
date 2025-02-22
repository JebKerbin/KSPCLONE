local PhysicsConstants = {
    -- Gravitational constant (scaled for Roblox)
    G = 6.67430e-11 * 1e-6,
    
    -- Celestial body properties
    KERBIN = {
        MASS = 5.2915793e22 * 1e-6,
        RADIUS = 600000 * 0.01, -- Scaled down for Roblox
        ATMOSPHERE_HEIGHT = 70000 * 0.01,
        SURFACE_GRAVITY = 9.81
    },
    
    MUN = {
        MASS = 9.759896e20 * 1e-6,
        RADIUS = 200000 * 0.01,
        SURFACE_GRAVITY = 1.63
    },
    
    MINMUS = {
        MASS = 2.6567705e19 * 1e-6,
        RADIUS = 60000 * 0.01,
        SURFACE_GRAVITY = 0.491
    },
    
    -- Part properties
    PARTS = {
        COMMAND_POD = {
            MASS = 1000,
            MAX_CREW = 1
        },
        FUEL_TANK = {
            MASS = 1250,
            FUEL_CAPACITY = 400
        },
        ENGINE = {
            MASS = 1500,
            THRUST = 205000,
            ISP = 290
        }
    }
}

return PhysicsConstants
