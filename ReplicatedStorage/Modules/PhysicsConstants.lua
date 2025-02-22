local PhysicsConstants = {
    -- Gravitational constant (scaled for Roblox studs)
    G = 6.67430e-11 * 1e-6,

    -- Physics configuration
    ZERO_GRAVITY_THRESHOLD = 1000,
    GRAVITY_FALLOFF_RATE = 2,
    MIN_GRAVITY = 0.001,
    SYSTEM_SCALE = 1, -- Using direct stud measurements

    -- Kerbol System (Star)
    KERBOL = {
        MASS = 1.7565459e28 * 1e-9,
        RADIUS = 2000,  -- Base size in studs
        SURFACE_GRAVITY = 17.1,
        ORBIT_RADIUS = 0,
        GRAVITY_RANGE = 4000
    },

    -- Inner Planets
    MOHO = {
        MASS = 2.5263314e21 * 1e-9,
        RADIUS = 250,
        SURFACE_GRAVITY = 2.70,
        ORBIT_RADIUS = 13000,
        GRAVITY_RANGE = 500
    },

    EVE = {
        MASS = 1.2243980e23 * 1e-9,
        RADIUS = 700,
        SURFACE_GRAVITY = 16.7,
        ATMOSPHERE_HEIGHT = 90,
        ORBIT_RADIUS = 23000,
        GRAVITY_RANGE = 1400
    },

    GILLY = {
        MASS = 1.2420512e17 * 1e-9,
        RADIUS = 65,
        SURFACE_GRAVITY = 0.049,
        ORBIT_RADIUS = 315,
        PARENT = "EVE",
        GRAVITY_RANGE = 130
    },

    KERBIN = {
        MASS = 5.2915793e22 * 1e-9,
        RADIUS = 600,
        ATMOSPHERE_HEIGHT = 70,
        SURFACE_GRAVITY = 9.81,
        ORBIT_RADIUS = 34000,
        GRAVITY_RANGE = 1200
    },

    MUN = {
        MASS = 9.7599066e20 * 1e-9,
        RADIUS = 200,
        SURFACE_GRAVITY = 1.63,
        ORBIT_RADIUS = 1200,
        PARENT = "KERBIN",
        GRAVITY_RANGE = 400
    },

    MINMUS = {
        MASS = 2.6457580e19 * 1e-9,
        RADIUS = 60,
        SURFACE_GRAVITY = 0.491,
        ORBIT_RADIUS = 2400,
        PARENT = "KERBIN",
        GRAVITY_RANGE = 120
    },

    DUNA = {
        MASS = 4.5154812e21 * 1e-9,
        RADIUS = 320,
        SURFACE_GRAVITY = 2.94,
        ATMOSPHERE_HEIGHT = 50,
        ORBIT_RADIUS = 52000,
        GRAVITY_RANGE = 640
    },

    IKE = {
        MASS = 2.7821949e20 * 1e-9,
        RADIUS = 130,
        SURFACE_GRAVITY = 1.10,
        ORBIT_RADIUS = 320,
        PARENT = "DUNA",
        GRAVITY_RANGE = 260
    },

    DRES = {
        MASS = 3.2191322e20 * 1e-9,
        RADIUS = 138,
        SURFACE_GRAVITY = 1.13,
        ORBIT_RADIUS = 102000,
        GRAVITY_RANGE = 276
    },

    JOOL = {
        MASS = 4.2332127e24 * 1e-9,
        RADIUS = 1200,
        SURFACE_GRAVITY = 7.85,
        ATMOSPHERE_HEIGHT = 200,
        ORBIT_RADIUS = 172000,
        GRAVITY_RANGE = 2400
    },

    LAYTHE = {
        MASS = 2.9397311e22 * 1e-9,
        RADIUS = 500,
        SURFACE_GRAVITY = 7.85,
        ATMOSPHERE_HEIGHT = 50,
        ORBIT_RADIUS = 1360,
        PARENT = "JOOL",
        GRAVITY_RANGE = 1000
    },

    VALL = {
        MASS = 3.1088028e21 * 1e-9,
        RADIUS = 300,
        SURFACE_GRAVITY = 2.31,
        ORBIT_RADIUS = 2160,
        PARENT = "JOOL",
        GRAVITY_RANGE = 600
    },

    TYLO = {
        MASS = 4.2332127e22 * 1e-9,
        RADIUS = 600,
        SURFACE_GRAVITY = 7.85,
        ORBIT_RADIUS = 3425,
        PARENT = "JOOL",
        GRAVITY_RANGE = 1200
    },

    BOP = {
        MASS = 3.7261536e19 * 1e-9,
        RADIUS = 65,
        SURFACE_GRAVITY = 0.589,
        ORBIT_RADIUS = 6425,
        PARENT = "JOOL",
        GRAVITY_RANGE = 130
    },

    POL = {
        MASS = 1.0813636e19 * 1e-9,
        RADIUS = 44,
        SURFACE_GRAVITY = 0.373,
        ORBIT_RADIUS = 9000,
        PARENT = "JOOL",
        GRAVITY_RANGE = 88
    },

    EELOO = {
        MASS = 1.1149224e21 * 1e-9,
        RADIUS = 210,
        SURFACE_GRAVITY = 1.69,
        ORBIT_RADIUS = 225250,
        GRAVITY_RANGE = 420
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