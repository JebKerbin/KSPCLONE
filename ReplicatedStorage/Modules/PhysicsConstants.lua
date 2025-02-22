local PhysicsConstants = {
    -- Gravitational constant (scaled for Roblox)
    G = 6.67430e-11 * 1e-6, -- Scaled down to prevent extreme forces

    -- Kerbol System (KSP1)
    KERBOL = {
        MASS = 1.7565459e28 * 1e-9,
        RADIUS = 261600000 * 0.005,
        SURFACE_GRAVITY = 17.1
    },

    MOHO = {
        MASS = 2.5263314e21 * 1e-9,
        RADIUS = 250000 * 0.005,
        SURFACE_GRAVITY = 2.70
    },

    EVE = {
        MASS = 1.2243980e23 * 1e-9,
        RADIUS = 700000 * 0.005,
        SURFACE_GRAVITY = 16.7,
        ATMOSPHERE_HEIGHT = 90000 * 0.005
    },

    GILLY = {
        MASS = 1.2420363e17 * 1e-9,
        RADIUS = 13000 * 0.005,
        SURFACE_GRAVITY = 0.049
    },

    KERBIN = {
        MASS = 5.2915793e22 * 1e-9,
        RADIUS = 600000 * 0.005,
        ATMOSPHERE_HEIGHT = 70000 * 0.005,
        SURFACE_GRAVITY = 9.81
    },

    MUN = {
        MASS = 9.7599066e20 * 1e-9,
        RADIUS = 200000 * 0.005,
        SURFACE_GRAVITY = 1.63
    },

    MINMUS = {
        MASS = 2.6457580e19 * 1e-9,
        RADIUS = 60000 * 0.005,
        SURFACE_GRAVITY = 0.491
    },

    DUNA = {
        MASS = 4.5154812e21 * 1e-9,
        RADIUS = 320000 * 0.005,
        SURFACE_GRAVITY = 2.94,
        ATMOSPHERE_HEIGHT = 50000 * 0.005
    },

    IKE = {
        MASS = 2.7821949e20 * 1e-9,
        RADIUS = 130000 * 0.005,
        SURFACE_GRAVITY = 1.10
    },

    DRES = {
        MASS = 3.2191322e20 * 1e-9,
        RADIUS = 138000 * 0.005,
        SURFACE_GRAVITY = 1.13
    },

    JOOL = {
        MASS = 4.2332127e24 * 1e-9,
        RADIUS = 6000000 * 0.005,
        SURFACE_GRAVITY = 7.85,
        ATMOSPHERE_HEIGHT = 200000 * 0.005
    },

    LAYTHE = {
        MASS = 2.9397311e22 * 1e-9,
        RADIUS = 500000 * 0.005,
        SURFACE_GRAVITY = 7.85,
        ATMOSPHERE_HEIGHT = 50000 * 0.005
    },

    VALL = {
        MASS = 3.1088028e21 * 1e-9,
        RADIUS = 300000 * 0.005,
        SURFACE_GRAVITY = 2.31
    },

    TYLO = {
        MASS = 4.2332127e22 * 1e-9,
        RADIUS = 600000 * 0.005,
        SURFACE_GRAVITY = 7.85
    },

    BOP = {
        MASS = 3.7261090e19 * 1e-9,
        RADIUS = 65000 * 0.005,
        SURFACE_GRAVITY = 0.589
    },

    POL = {
        MASS = 1.0813636e19 * 1e-9,
        RADIUS = 44000 * 0.005,
        SURFACE_GRAVITY = 0.373
    },

    EELOO = {
        MASS = 1.1149224e21 * 1e-9,
        RADIUS = 210000 * 0.005,
        SURFACE_GRAVITY = 1.69
    },

    -- KSP2 Additions
    OVIN = {
        MASS = 1.8e21 * 1e-9,
        RADIUS = 250000 * 0.005,
        SURFACE_GRAVITY = 1.92
    },

    GARGANTUA = {
        MASS = 3.2e24 * 1e-9,
        RADIUS = 5000000 * 0.005,
        SURFACE_GRAVITY = 8.51,
        ATMOSPHERE_HEIGHT = 180000 * 0.005
    },

    GLUMO = {
        MASS = 2.1e22 * 1e-9,
        RADIUS = 450000 * 0.005,
        SURFACE_GRAVITY = 6.89
    },

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