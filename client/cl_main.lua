local interactedGraves = {}

local function spawnAngryNPC()
    local npcModel = GetHashKey("cs_priest") 
    RequestModel(npcModel)

    while not HasModelLoaded(npcModel) do
        Wait(500)
    end

    local npc = CreatePed(4, npcModel, YK.PedCoords.x, YK.PedCoords.y, YK.PedCoords.z + 1.0, 0.0, true, true)

    SetEntityAsMissionEntity(npc, true, true)
    TaskCombatPed(npc, PlayerPedId(), 0, 16) 

    GiveWeaponToPed(npc, GetHashKey(YK.Weapon), 9999, true, true)

    SetEntityHealth(npc, 100) 
    SetPedCombatAttributes(npc, 46, true) 
end

for _, grave in ipairs(YK.GraveLocations) do
    exports.ox_target:addBoxZone({
        coords = grave.coords,
        size = grave.size,
        rotation = grave.rotation,
        debug = false,
        options = {
            {
                icon = 'fa-solid fa-skull',
                label = 'Dig',
                items = YK.RequiredItem,
                onSelect = function(data)

                    if interactedGraves[grave.coords] then
                        lib.notify({
                            id = 'grave_digging',
                            title = 'Gravedigging',
                            description = 'You have already dug this grave!',
                            showDuration = false,
                            position = 'top',
                            style = {
                                backgroundColor = '#141517',
                                color = '#C1C2C5',
                                ['.description'] = {
                                    color = '#909296'
                                }
                            },
                            icon = 'fa-solid fa-exclamation-triangle',
                            iconColor = '#FFC107'
                        })
                        return 
                    end

                    local success = lib.skillCheck({'easy', 'easy', 'easy', 'easy', 'easy'}, {'e'})

                    if success then
                        if lib.progressCircle({
                            duration = 10000,
                            label = 'Digging...',
                            position = 'bottom',
                            useWhileDead = false,
                            canCancel = true,
                            disable = {
                                car = true,
                            },
                            anim = {
                                dict = "random@burial",
                                clip = "a_burial",
                            },
                            prop = {
                                model = GetHashKey("prop_tool_shovel"),
                                bone = 28422,
                                pos = vector3(0.03, 0.01, 0.2),
                                rot = vector3(0.0, 0.0, -9.5)
                            },
                            disable = {
                                move = true,
                                sprint = true,
                                car = true
                            },
                        }) then
                            interactedGraves[grave.coords] = true

                            lib.notify({
                                id = 'grave_digging',
                                title = 'Gravedigging',
                                description = 'You dug a grave',
                                showDuration = false,
                                position = 'top',
                                style = {
                                    backgroundColor = '#141517',
                                    color = '#C1C2C5',
                                    ['.description'] = {
                                        color = '#909296'
                                    }
                                },
                                icon = 'fa-solid fa-check',
                                iconColor = '#28A745'
                            })

                            local npcChance = math.random(1, 100)
                            if npcChance <= YK.NPCSpawnChance then
                                spawnAngryNPC()
                            end

                            TriggerServerEvent("giveitems")
                            
                            -- Put here your dispatch
                            
                        end
                    else
                        lib.notify({
                            id = 'grave_digging',
                            title = 'Gravedigging',
                            description = 'You failed!',
                            showDuration = false,
                            position = 'top',
                            style = {
                                backgroundColor = '#141517',
                                color = '#C1C2C5',
                                ['.description'] = {
                                    color = '#909296'
                                }
                            },
                            icon = 'fa-solid fa-ban',
                            iconColor = '#C53030'
                        })
                    end
                end
            }
        }
    })
end
