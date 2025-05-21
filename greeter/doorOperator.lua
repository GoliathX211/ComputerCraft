local detector
local integrator

local function setDetector(peripheral)
    detector = peripheral
end

local function setIntegrator(peripheral)
    integrator = peripheral
end

local allowed = {
    "GoliathX211",
    "Lightman314",
    "peacock11",
    "54sam3",
    "LargeOrbitalObject"
}

local function isAllowed(player)
    for index, user in pairs(allowed) do
        if (user == player)
        then
            return true
        end
    end
    return false
end

local function shouldOpen()
    local region = {
        pos1={x=-1877, y=64, z=-2516}, 
        pos2={x=-1889, y=69, z=-2508}
    }
    local detected = detector.getPlayersInCoords(region.pos1, region.pos2)
    if (#detected == 0)
    then
        return false  -- There are not players in the detection region
    end
    for index, player in pairs(detected) do
        if (isAllowed(player))
        then
            return true
        end
    end
    return false
end

local function run()
    while true do
        if (shouldOpen())
        then
            integrator.setOutput("top", true)
        else
            integrator.setOutput("top", false)
        end
    end
end

return {run = run, isAllowed = isAllowed, allowed = allowed, setDetector = setDetector, setIntegrator = setIntegrator}