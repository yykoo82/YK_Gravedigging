local interactedGraves = {}

for _, grave in ipairs(Config.GraveLocations) do
    exports.ox_target:addBoxZone({
        coords = grave.coords,
        size = grave.size,
        rotation = grave.rotation,
        debug = true,
        options = {
            {
                icon = 'fa-solid fa-skull',
                label = 'Dig',
                items = Config.RequiredItem,
                onSelect = function(data)
                
                    if interactedGraves[grave.coords] then
                        lib.notify({
                            id = 'grave_digging',
                            title = 'Gravedigging',
                            description = 'You have already digged this grave!',
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
                                description = 'You digged a grave',
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
                            if npcChance <= Config.NPCSpawnChance then
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
