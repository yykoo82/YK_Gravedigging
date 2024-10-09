RegisterNetEvent("giveitems", function ()
    local player = source
    local itemsGiven = {} 

    for _, item in ipairs(Config.Items) do
        local roll = math.random(1, 100)
        if roll <= item.chance then
            local amount = math.random(item.min, item.max)
            exports.ox_inventory:AddItem(player, item.name, amount)
            table.insert(itemsGiven, item.name) 
        end
    end

    if #itemsGiven == 0 then
        TriggerClientEvent('ox_lib:notify', player, {
            title = 'Gravedigging',
            description = 'You didnt find anything!',
            type = 'error',
            position = 'top',
            style = {
                backgroundColor = '#141517',
                color = '#C1C2C5',
                ['.description'] = {
                    color = '#909296'
                }
            }
        })
    end
end)
