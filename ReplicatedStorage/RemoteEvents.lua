local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Create all RemoteEvents
local Events = {
    "UpdateThrottle",
    "UpdateRotation",
    "ToggleSAS",
    "Stage",
    "SpacecraftUpdate",
    "CelestialBodyUpdate"
}

local RemoteEvents = {}

for _, eventName in ipairs(Events) do
    local event = Instance.new("RemoteEvent")
    event.Name = eventName
    event.Parent = ReplicatedStorage
    RemoteEvents[eventName] = event
    print(string.format("[RemoteEvents] Created %s", eventName))
end

return RemoteEvents
