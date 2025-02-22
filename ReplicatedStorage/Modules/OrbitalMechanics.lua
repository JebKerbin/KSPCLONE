local PhysicsConstants = require(game.ReplicatedStorage.Modules.PhysicsConstants)

local OrbitalMechanics = {}

function OrbitalMechanics.calculateGravitationalForce(mass1, mass2, position1, position2)
    local direction = (position2 - position1).Unit
    local distance = (position2 - position1).Magnitude
    local force = PhysicsConstants.G * mass1 * mass2 / (distance * distance)
    return direction * force
end

function OrbitalMechanics.calculateOrbitalVelocity(centralMass, radius)
    return math.sqrt(PhysicsConstants.G * centralMass / radius)
end

function OrbitalMechanics.calculateOrbitalPeriod(centralMass, semiMajorAxis)
    return 2 * math.pi * math.sqrt(semiMajorAxis * semiMajorAxis * semiMajorAxis / (PhysicsConstants.G * centralMass))
end

function OrbitalMechanics.calculateApoapsisPeriapsis(position, velocity, centralBody)
    local mu = PhysicsConstants.G * centralBody.MASS
    local r = position.Magnitude
    local v = velocity.Magnitude
    
    local specificEnergy = (v * v / 2) - (mu / r)
    local angularMomentum = position:Cross(velocity).Magnitude
    
    local a = -mu / (2 * specificEnergy)
    local e = math.sqrt(1 + (2 * specificEnergy * angularMomentum * angularMomentum) / (mu * mu))
    
    local periapsis = a * (1 - e)
    local apoapsis = a * (1 + e)
    
    return apoapsis, periapsis
end

return OrbitalMechanics
