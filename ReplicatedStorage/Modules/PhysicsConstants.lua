local PhysicsConstants = {
    -- Gravitational constant (scaled for Roblox)
    G = 6.67430e-11 * 1e-6, -- Scaled down to prevent extreme forces

    -- Physics configuration
    ZERO_GRAVITY_THRESHOLD = 1000,
    GRAVITY_FALLOFF_RATE = 2,
    MIN_GRAVITY = 0.001,
    SYSTEM_SCALE = 0.005,

    -- KSP1 Solar System
    KERBOL = {
        MASS = 1.7565459e28 * 1e-9,
        RADIUS = 261600000 * 0.005,
        SURFACE_GRAVITY = 17.1,
        ORBIT_RADIUS = 0,
        GRAVITY_RANGE = 800000
    },

    -- KSP1 Inner Planets
    MOHO = {
        MASS = 2.5263314e21 * 1e-9,
        RADIUS = 250000 * 0.005,
        SURFACE_GRAVITY = 2.70,
        ORBIT_RADIUS = 5263138304 * 0.005,
        GRAVITY_RANGE = 50000
    },

    EVE = {
        MASS = 1.2243980e23 * 1e-9,
        RADIUS = 700000 * 0.005,
        SURFACE_GRAVITY = 16.7,
        ATMOSPHERE_HEIGHT = 90000 * 0.005,
        ORBIT_RADIUS = 9832684544 * 0.005,
        GRAVITY_RANGE = 100000
    },

    GILLY = {
        MASS = 1.2420512e17 * 1e-9,
        RADIUS = 13000 * 0.005,
        SURFACE_GRAVITY = 0.049,
        ORBIT_RADIUS = 31500000 * 0.005,
        PARENT = "EVE",
        GRAVITY_RANGE = 8000
    },

    KERBIN = {
        MASS = 5.2915793e22 * 1e-9,
        RADIUS = 600000 * 0.005,
        ATMOSPHERE_HEIGHT = 70000 * 0.005,
        SURFACE_GRAVITY = 9.81,
        ORBIT_RADIUS = 13599840256 * 0.005,
        GRAVITY_RANGE = 80000
    },

    MUN = {
        MASS = 9.7599066e20 * 1e-9,
        RADIUS = 200000 * 0.005,
        SURFACE_GRAVITY = 1.63,
        ORBIT_RADIUS = 12000000 * 0.005,
        PARENT = "KERBIN",
        GRAVITY_RANGE = 30000
    },

    MINMUS = {
        MASS = 2.6457580e19 * 1e-9,
        RADIUS = 60000 * 0.005,
        SURFACE_GRAVITY = 0.491,
        ORBIT_RADIUS = 47000000 * 0.005,
        PARENT = "KERBIN",
        GRAVITY_RANGE = 20000
    },

    DUNA = {
        MASS = 4.5154812e21 * 1e-9,
        RADIUS = 320000 * 0.005,
        SURFACE_GRAVITY = 2.94,
        ATMOSPHERE_HEIGHT = 50000 * 0.005,
        ORBIT_RADIUS = 20726155264 * 0.005,
        GRAVITY_RANGE = 60000
    },

    IKE = {
        MASS = 2.7821949e20 * 1e-9,
        RADIUS = 130000 * 0.005,
        SURFACE_GRAVITY = 1.10,
        ORBIT_RADIUS = 3200000 * 0.005,
        PARENT = "DUNA",
        GRAVITY_RANGE = 25000
    },

    DRES = {
        MASS = 3.2191322e20 * 1e-9,
        RADIUS = 138000 * 0.005,
        SURFACE_GRAVITY = 1.13,
        ORBIT_RADIUS = 40839348203 * 0.005,
        GRAVITY_RANGE = 40000
    },

    JOOL = {
        MASS = 4.2332127e24 * 1e-9,
        RADIUS = 6000000 * 0.005,
        SURFACE_GRAVITY = 7.85,
        ATMOSPHERE_HEIGHT = 200000 * 0.005,
        ORBIT_RADIUS = 68773560320 * 0.005,
        GRAVITY_RANGE = 200000
    },

    LAYTHE = {
        MASS = 2.9397311e22 * 1e-9,
        RADIUS = 500000 * 0.005,
        SURFACE_GRAVITY = 7.85,
        ATMOSPHERE_HEIGHT = 50000 * 0.005,
        ORBIT_RADIUS = 27184000 * 0.005,
        PARENT = "JOOL",
        GRAVITY_RANGE = 70000
    },

    VALL = {
        MASS = 3.1088028e21 * 1e-9,
        RADIUS = 300000 * 0.005,
        SURFACE_GRAVITY = 2.31,
        ORBIT_RADIUS = 43152000 * 0.005,
        PARENT = "JOOL",
        GRAVITY_RANGE = 50000
    },

    TYLO = {
        MASS = 4.2332127e22 * 1e-9,
        RADIUS = 600000 * 0.005,
        SURFACE_GRAVITY = 7.85,
        ORBIT_RADIUS = 68500000 * 0.005,
        PARENT = "JOOL",
        GRAVITY_RANGE = 80000
    },

    BOP = {
        MASS = 3.7261536e19 * 1e-9,
        RADIUS = 65000 * 0.005,
        SURFACE_GRAVITY = 0.589,
        ORBIT_RADIUS = 128500000 * 0.005,
        PARENT = "JOOL",
        GRAVITY_RANGE = 25000
    },

    POL = {
        MASS = 1.0813636e19 * 1e-9,
        RADIUS = 44000 * 0.005,
        SURFACE_GRAVITY = 0.373,
        ORBIT_RADIUS = 179890000 * 0.005,
        PARENT = "JOOL",
        GRAVITY_RANGE = 20000
    },

    EELOO = {
        MASS = 1.1149224e21 * 1e-9,
        RADIUS = 210000 * 0.005,
        SURFACE_GRAVITY = 1.69,
        ORBIT_RADIUS = 90118820000 * 0.005,
        GRAVITY_RANGE = 45000
    },

    -- KSP2 New Star Systems
    CIRO = { -- KSP2's version of the Sun
        MASS = 1.7565459e28 * 1e-9,
        RADIUS = 261600000 * 0.005,
        SURFACE_GRAVITY = 17.1,
        ORBIT_RADIUS = 0,
        GRAVITY_RANGE = 800000
    },

    -- Gargantuan System
    GARGANTUA = { -- Binary partner of Ciro
        MASS = 2.1956824e28 * 1e-9,
        RADIUS = 300000000 * 0.005,
        SURFACE_GRAVITY = 19.5,
        ORBIT_RADIUS = 150000000000 * 0.005,
        GRAVITY_RANGE = 1000000
    },

    GLUMO = {
        MASS = 8.4664254e22 * 1e-9,
        RADIUS = 800000 * 0.005,
        SURFACE_GRAVITY = 8.8,
        ATMOSPHERE_HEIGHT = 80000 * 0.005,
        ORBIT_RADIUS = 12000000000 * 0.005,
        PARENT = "GARGANTUA",
        GRAVITY_RANGE = 100000
    },

    -- Ovin System
    OVIN = {
        MASS = 3.9152283e23 * 1e-9,
        RADIUS = 1200000 * 0.005,
        SURFACE_GRAVITY = 18.2,
        ATMOSPHERE_HEIGHT = 150000 * 0.005,
        ORBIT_RADIUS = 80000000000 * 0.005,
        GRAVITY_RANGE = 150000
    },

    MAYOR = {
        MASS = 1.2420512e21 * 1e-9,
        RADIUS = 250000 * 0.005,
        SURFACE_GRAVITY = 1.3,
        ORBIT_RADIUS = 5000000 * 0.005,
        PARENT = "OVIN",
        GRAVITY_RANGE = 40000
    },

    REGENT = {
        MASS = 8.9427686e20 * 1e-9,
        RADIUS = 180000 * 0.005,
        SURFACE_GRAVITY = 1.8,
        ORBIT_RADIUS = 8000000 * 0.005,
        PARENT = "OVIN",
        GRAVITY_RANGE = 35000
    },

    -- Part specifications remain unchanged
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