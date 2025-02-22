local PhysicsConstants = {
    -- Gravitational constant (scaled for Roblox studs)
    G = 6.67430e-11 * 1e-6,

    -- Physics configuration
    ZERO_GRAVITY_THRESHOLD = 1000,
    GRAVITY_FALLOFF_RATE = 2,
    MIN_GRAVITY = 0.001,
    SYSTEM_SCALE = 1, -- Now using direct stud measurements

    -- KSP1 Solar System
    KERBOL = {
        MASS = 1.7565459e28 * 1e-9,
        RADIUS = 2048, -- Base size in studs (2048x2 for full width)
        SURFACE_GRAVITY = 17.1,
        ORBIT_RADIUS = 0,
        GRAVITY_RANGE = 4096
    },

    -- KSP1 Inner Planets
    MOHO = {
        MASS = 2.5263314e21 * 1e-9,
        RADIUS = 128, -- Scaled relative to Kerbol
        SURFACE_GRAVITY = 2.70,
        ORBIT_RADIUS = 26000,
        GRAVITY_RANGE = 256
    },

    EVE = {
        MASS = 1.2243980e23 * 1e-9,
        RADIUS = 350,
        SURFACE_GRAVITY = 16.7,
        ATMOSPHERE_HEIGHT = 90,
        ORBIT_RADIUS = 45000,
        GRAVITY_RANGE = 700
    },

    GILLY = {
        MASS = 1.2420512e17 * 1e-9,
        RADIUS = 6.5,
        SURFACE_GRAVITY = 0.049,
        ORBIT_RADIUS = 315,
        PARENT = "EVE",
        GRAVITY_RANGE = 13
    },

    KERBIN = {
        MASS = 5.2915793e22 * 1e-9,
        RADIUS = 300,
        ATMOSPHERE_HEIGHT = 70,
        SURFACE_GRAVITY = 9.81,
        ORBIT_RADIUS = 68000,
        GRAVITY_RANGE = 600
    },

    MUN = {
        MASS = 9.7599066e20 * 1e-9,
        RADIUS = 100,
        SURFACE_GRAVITY = 1.63,
        ORBIT_RADIUS = 1200,
        PARENT = "KERBIN",
        GRAVITY_RANGE = 200
    },

    MINMUS = {
        MASS = 2.6457580e19 * 1e-9,
        RADIUS = 30,
        SURFACE_GRAVITY = 0.491,
        ORBIT_RADIUS = 4700,
        PARENT = "KERBIN",
        GRAVITY_RANGE = 60
    },

    DUNA = {
        MASS = 4.5154812e21 * 1e-9,
        RADIUS = 160,
        SURFACE_GRAVITY = 2.94,
        ATMOSPHERE_HEIGHT = 50,
        ORBIT_RADIUS = 103000,
        GRAVITY_RANGE = 320
    },

    IKE = {
        MASS = 2.7821949e20 * 1e-9,
        RADIUS = 65,
        SURFACE_GRAVITY = 1.10,
        ORBIT_RADIUS = 320,
        PARENT = "DUNA",
        GRAVITY_RANGE = 130
    },

    DRES = {
        MASS = 3.2191322e20 * 1e-9,
        RADIUS = 69,
        SURFACE_GRAVITY = 1.13,
        ORBIT_RADIUS = 204000,
        GRAVITY_RANGE = 138
    },

    JOOL = {
        MASS = 4.2332127e24 * 1e-9,
        RADIUS = 600,
        SURFACE_GRAVITY = 7.85,
        ATMOSPHERE_HEIGHT = 200,
        ORBIT_RADIUS = 343000,
        GRAVITY_RANGE = 1200
    },

    LAYTHE = {
        MASS = 2.9397311e22 * 1e-9,
        RADIUS = 250,
        SURFACE_GRAVITY = 7.85,
        ATMOSPHERE_HEIGHT = 50,
        ORBIT_RADIUS = 2718,
        PARENT = "JOOL",
        GRAVITY_RANGE = 500
    },

    VALL = {
        MASS = 3.1088028e21 * 1e-9,
        RADIUS = 150,
        SURFACE_GRAVITY = 2.31,
        ORBIT_RADIUS = 4315,
        PARENT = "JOOL",
        GRAVITY_RANGE = 300
    },

    TYLO = {
        MASS = 4.2332127e22 * 1e-9,
        RADIUS = 300,
        SURFACE_GRAVITY = 7.85,
        ORBIT_RADIUS = 6850,
        PARENT = "JOOL",
        GRAVITY_RANGE = 600
    },

    BOP = {
        MASS = 3.7261536e19 * 1e-9,
        RADIUS = 32.5,
        SURFACE_GRAVITY = 0.589,
        ORBIT_RADIUS = 12850,
        PARENT = "JOOL",
        GRAVITY_RANGE = 65
    },

    POL = {
        MASS = 1.0813636e19 * 1e-9,
        RADIUS = 22,
        SURFACE_GRAVITY = 0.373,
        ORBIT_RADIUS = 17989,
        PARENT = "JOOL",
        GRAVITY_RANGE = 44
    },

    EELOO = {
        MASS = 1.1149224e21 * 1e-9,
        RADIUS = 105,
        SURFACE_GRAVITY = 1.69,
        ORBIT_RADIUS = 450500,
        GRAVITY_RANGE = 210
    },

    -- KSP2 New Star Systems
    CIRO = { -- KSP2's version of the Sun
        MASS = 1.7565459e28 * 1e-9,
        RADIUS = 2048,
        SURFACE_GRAVITY = 17.1,
        ORBIT_RADIUS = 0,
        GRAVITY_RANGE = 4096
    },

    -- Gargantuan System
    GARGANTUA = { -- Binary partner of Ciro
        MASS = 2.1956824e28 * 1e-9,
        RADIUS = 2350,
        SURFACE_GRAVITY = 19.5,
        ORBIT_RADIUS = 750000,
        GRAVITY_RANGE = 4700
    },

    GLUMO = {
        MASS = 8.4664254e22 * 1e-9,
        RADIUS = 400,
        SURFACE_GRAVITY = 8.8,
        ATMOSPHERE_HEIGHT = 80,
        ORBIT_RADIUS = 60000,
        PARENT = "GARGANTUA",
        GRAVITY_RANGE = 800
    },

    -- Ovin System
    OVIN = {
        MASS = 3.9152283e23 * 1e-9,
        RADIUS = 600,
        SURFACE_GRAVITY = 18.2,
        ATMOSPHERE_HEIGHT = 150,
        ORBIT_RADIUS = 400000,
        GRAVITY_RANGE = 1200
    },

    MAYOR = {
        MASS = 1.2420512e21 * 1e-9,
        RADIUS = 125,
        SURFACE_GRAVITY = 1.3,
        ORBIT_RADIUS = 500,
        PARENT = "OVIN",
        GRAVITY_RANGE = 250
    },

    REGENT = {
        MASS = 8.9427686e20 * 1e-9,
        RADIUS = 90,
        SURFACE_GRAVITY = 1.8,
        ORBIT_RADIUS = 800,
        PARENT = "OVIN",
        GRAVITY_RANGE = 180
    },

    -- Part specifications
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