local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('ggwpx-warehouse:server:RemoveWarehouse', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player then
        exports.oxmysql:execute(
            'DELETE FROM warehouse WHERE citizenid = ? AND location = ? AND name = ? AND id = ?',
            {Player.PlayerData.citizenid, data.location, data.name, data.id},
            function(affectedRows)
                if affectedRows > 0 then
                    TriggerClientEvent('QBCore:Notify', src, Config.Languages[Config.Language]['remove_warehouse'], 'success')
                else
                    TriggerClientEvent('QBCore:Notify', src, Config.Languages[Config.Language]['warehouse_not_found'], 'error')
                end
            end
        )
    else
        TriggerClientEvent('QBCore:Notify', src, Config.Languages[Config.Language]['player_not_found'], 'error')
    end
end)

QBCore.Functions.CreateCallback('ggwpx-warehouse:server:BuyWarehouse', function(source, cb, data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player then
        local price = Config.Locations[data.location]['price']
        if Player.Functions.GetMoney('bank') >= price then
            Player.Functions.RemoveMoney('bank', price, "Warehouse Purchase")
            exports.oxmysql:insert(
                'INSERT INTO warehouse (`location`, `name`, `password`, `citizenid`) VALUES (?, ?, ?, ?)',
                {data.location, data.name, data.password, Player.PlayerData.citizenid},
                function(insertId)
                    if insertId then
                        cb(true)
                        TriggerClientEvent('QBCore:Notify', src, Config.Languages[Config.Language]['warehouse_purchased'], 'success')
                    else
                        cb(false)
                        TriggerClientEvent('QBCore:Notify', src, Config.Languages[Config.Language]['db_insert_error'], 'error')
                    end
                end
            )
        else
            cb(false)
            TriggerClientEvent('QBCore:Notify', src, Config.Languages[Config.Language]['insufficient_funds'], 'error')
        end
    else
        cb(false)
        TriggerClientEvent('QBCore:Notify', src, Config.Languages[Config.Language]['player_not_found'], 'error')
    end
end)

QBCore.Functions.CreateCallback('ggwpx-warehouse:server:GetWarehouse', function(source, cb, location)
    exports.oxmysql:execute('SELECT * FROM warehouse WHERE location = ?', {location}, function(result)
        cb(result)
    end)
end)

QBCore.Functions.CreateCallback('ggwpx-warehouse:server:GetWarehouseCitizenId', function(source, cb, location)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player then
        exports.oxmysql:execute(
            'SELECT * FROM warehouse WHERE location = ? AND citizenid = ?',
            {location, Player.PlayerData.citizenid},
            function(result)
                cb(result and result[1] or nil) 
            end
        )
    else
        cb(nil)
    end
end)