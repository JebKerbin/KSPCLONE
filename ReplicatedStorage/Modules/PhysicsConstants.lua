local PhysicsConstants = {
    -- Gravitational constant (scaled for Roblox)
    G = 6.67430e-11 * 1e-6, -- Scaled down to prevent extreme forces

    -- Physics configuration
    ZERO_GRAVITY_THRESHOLD = 1000, -- Distance beyond which gravity becomes negligible
    GRAVITY_FALLOFF_RATE = 2, -- Square of distance falloff (realistic)
    MIN_GRAVITY = 0.001, -- Minimum gravity force to prevent complete weightlessness

    -- Solar System Scale (in Roblox studs)
    SYSTEM_SCALE = 0.005, -- Scale factor for the entire system

    -- Kerbol System (KSP1)
    KERBOL = {
        MASS = 1.7565459e28 * 1e-9,
        RADIUS = 261600000 * 0.005,
        SURFACE_GRAVITY = 17.1,
        ORBIT_RADIUS = 0, -- Center of system
        GRAVITY_RANGE = 800000 -- Range where gravity is significant
    },

    -- Inner Planets
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

    KERBIN = {
        MASS = 5.2915793e22 * 1e-9,
        RADIUS = 600000 * 0.005,
        ATMOSPHERE_HEIGHT = 70000 * 0.005,
        SURFACE_GRAVITY = 9.81,
        ORBIT_RADIUS = 13599840256 * 0.005,
        GRAVITY_RANGE = 80000
    },

    DUNA = {
        MASS = 4.5154812e21 * 1e-9,
        RADIUS = 320000 * 0.005,
        SURFACE_GRAVITY = 2.94,
        ATMOSPHERE_HEIGHT = 50000 * 0.005,
        ORBIT_RADIUS = 20726155264 * 0.005,
        GRAVITY_RANGE = 60000
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

    EELOO = {
        MASS = 1.1149224e21 * 1e-9,
        RADIUS = 210000 * 0.005,
        SURFACE_GRAVITY = 1.69,
        ORBIT_RADIUS = 90118820000 * 0.005,
        GRAVITY_RANGE = 45000
    },

    -- Moons
    MUN = {
        MASS = 9.7599066e20 * 1e-9,
        RADIUS = 200000 * 0.005,
        SURFACE_GRAVITY = 1.63,
        ORBIT_RADIUS = 12000000 * 0.005, -- Relative to Kerbin
        PARENT = "KERBIN",
        GRAVITY_RANGE = 30000
    },

    MINMUS = {
        MASS = 2.6457580e19 * 1e-9,
        RADIUS = 60000 * 0.005,
        SURFACE_GRAVITY = 0.491,
        ORBIT_RADIUS = 47000000 * 0.005, -- Relative to Kerbin
        PARENT = "KERBIN",
        GRAVITY_RANGE = 20000
    },

    -- Asteroid Belt Configuration
    ASTEROID_BELT = {
        INNER_RADIUS = 40839348203 * 0.005, -- Near Dres
        OUTER_RADIUS = 68773560320 * 0.005, -- Near Jool
        DENSITY = 0.1, -- Asteroid density in the belt
        ASTEROID_SIZES = {
            MIN = 10,
            MAX = 100
        }
    },

    -- Space Debris Configuration
    SPACE_DEBRIS = {
        SPAWN_RATE = 0.1, -- Debris spawned per minute
        MIN_LIFETIME = 300, -- Minimum time before debris despawns
        MAX_LIFETIME = 1800, -- Maximum time before debris despawns
        SIZE_RANGE = {
            MIN = 1,
            MAX = 5
        }
    },

    -- Comet Configuration
    COMETS = {
        SPAWN_RATE = 0.05, -- Comets spawned per minute
        TAIL_LENGTH = 50, -- Visual tail length
        SIZE_RANGE = {
            MIN = 20,
            MAX = 200
        },
        ORBIT_ECCENTRICITY = {
            MIN = 0.6,
            MAX = 0.9
        }
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