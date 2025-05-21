local detector = peripheral.wrap("bottom")
local integrator = peripheral.wrap("top")
local chatbox = peripheral.wrap("right")


DoorOperator = require("doorOperator")
DoorOperator.setDetector(detector)
DoorOperator.setIntegrator(integrator)

local entrance = { pos1 = { x = -1883, y = 69, z = -2516 }, pos2 = { x = -1887, y = 64, z = -2508 } }
local exit = { pos1 = { x = -1883, y = 69, z = -2516 }, pos2 = { x = -1877, y = 64, z = -2508 } }

local memory = {}

local function doesRemember(player)
    for remembered, time in pairs(memory) do
        if (remembered == player and time > 0)
        then
            return true
        end
    end
    return false
end

local function welcome()
    while true do
        local detected = detector.getPlayersInCoords(entrance.pos1, entrance.pos2)
        for index, player in next, detected do
            if (DoorOperator.isAllowed(player))
            then
                if (not doesRemember(player))
                then
                    memory[player] = 60
                    chatbox.sendToastToPlayer(
                        "Welcome to the factory " .. player .. ".",
                        "Access Granted",
                        player
                    )
                end
            else
                if (not doesRemember(player)) then
                    memory[player] = 60
                    chatbox.sendToastToPlayer(
                        player .. ", you do not have access to this door. If you are not welcome, please leave.",
                        "Access Denied",
                        player
                    )
                end
            end
        end
    end
end

local function clock()
    while true do
        for player, time in pairs(memory) do
            if (time > 0)
            then
                memory[player] = time - 1
            end
        end
        os.sleep(1)
    end
end

local function run()
    parallel.waitForAny(DoorOperator.run, welcome, clock)
end

run()