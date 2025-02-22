local PhysicsConstants = require(game.ReplicatedStorage.Modules.PhysicsConstants)

-- Cache frequently used functions and values
local sqrt = math.sqrt
local pi = math.pi
local Vector3_new = Vector3.new
local CFrame_new = CFrame.new

local OrbitalMechanics = {}

-- Optimized gravitational force calculation using CFrame
function OrbitalMechanics.calculateGravitationalForce(mass1, mass2, position1, position2)
    local displacement = position2 - position1
    local distanceSquared = displacement.Magnitude * displacement.Magnitude
    local force = PhysicsConstants.G * mass1 * mass2 / distanceSquared
    return displacement.Unit * force
end

-- Calculate orbital velocity with cached math operations
function OrbitalMechanics.calculateOrbitalVelocity(centralMass, radius)
    return sqrt(PhysicsConstants.G * centralMass / radius)
end

-- Optimized orbital period calculation
function OrbitalMechanics.calculateOrbitalPeriod(centralMass, semiMajorAxis)
    local cubed = semiMajorAxis * semiMajorAxis * semiMajorAxis
    return 2 * pi * sqrt(cubed / (PhysicsConstants.G * centralMass))
end

-- Calculate apoapsis and periapsis using optimized vector operations
function OrbitalMechanics.calculateApoapsisPeriapsis(position, velocity, centralBody)
    local mu = PhysicsConstants.G * centralBody.MASS
    local r = position.Magnitude
    local v = velocity.Magnitude

    -- Pre-calculate common values
    local v_squared = v * v
    local specific_energy = (v_squared / 2) - (mu / r)
    local h = position:Cross(velocity).Magnitude
    local h_squared = h * h

    -- Semi-major axis
    local a = -mu / (2 * specific_energy)

    -- Eccentricity using optimized calculation
    local e = sqrt(1 + (2 * specific_energy * h_squared) / (mu * mu))

    -- Calculate periapsis and apoapsis
    local periapsis = a * (1 - e)
    local apoapsis = a * (1 + e)

    return apoapsis, periapsis
end

-- Add orbital element conversion functions for efficiency
function OrbitalMechanics.cartesianToOrbitalElements(position, velocity, centralBody)
    local mu = PhysicsConstants.G * centralBody.MASS
    local r = position.Magnitude
    local v = velocity.Magnitude
    local h = position:Cross(velocity)

    -- Pre-calculate common values
    local h_mag = h.Magnitude
    local n = Vector3_new(-h.Y, h.X, 0).Unit
    local e_vec = ((v * v - mu / r) * position - position:Dot(velocity) * velocity) / mu
    local e = e_vec.Magnitude

    -- Calculate orbital elements
    local a = -mu / (2 * ((v * v / 2) - (mu / r)))
    local i = math.acos(h.Y / h_mag)
    local omega = math.acos(n.X)
    if n.Z < 0 then omega = 2 * pi - omega end

    return {
        semiMajorAxis = a,
        eccentricity = e,
        inclination = i,
        argumentOfPeriapsis = omega,
        angularMomentum = h_mag
    }
end

return OrbitalMechanics