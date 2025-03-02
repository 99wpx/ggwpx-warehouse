
local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = {} 

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)


RegisterNetEvent('ggwpx-warehouse:client:OpenMenu', function(warehouse)
    QBCore.Functions.TriggerCallback('ggwpx-warehouse:server:GetWarehouseCitizenId', function(hasWarehouse)
        local menuItems = {
            {
                header = Config.Locations[warehouse]['label'],
                isMenuHeader = true,
            },
        }

        if hasWarehouse then
            table.insert(menuItems, {
                header = Config.Languages[Config.Language]['my_warehouse'],
                txt = Config.Languages[Config.Language]['my_warehouse_list'],
                params = {
                    event = 'ggwpx-warehouse:client:MyWarehouseList',
                    args = {
                        warehouse = warehouse,
                    }
                }
            })
        end

        if not hasWarehouse then
            table.insert(menuItems, {
                header = Config.Languages[Config.Language]['buy_warehouse'],
                txt = Config.Languages[Config.Language]['buy_a_warehouse'],
                params = {
                    event = 'ggwpx-warehouse:client:BuyWarehouse',
                    args = {
                        warehouse = warehouse,
                    }
                }
            })
        end

        table.insert(menuItems, {
            header = Config.Languages[Config.Language]['warehouses'],
            txt = Config.Languages[Config.Language]['warehouse_list'],
            params = {
                event = 'ggwpx-warehouse:client:OpenWarehouseList',
                args = {
                    warehouse = warehouse,
                }
            }
        })

        exports['qb-menu']:openMenu(menuItems)
    end, warehouse)
end)

RegisterNetEvent('ggwpx-warehouse:client:BuyWarehouse', function(data)
    local warehouse = data.warehouse

    local input = exports['qb-input']:ShowInput({
        header = Config.Languages[Config.Language]['buy_warehouse']..' ($'..Config.Locations[warehouse]['price']..')',
        submitText = Config.Languages[Config.Language]['submit'],
        inputs = {
            {
                type = 'text',
                isRequired = true,
                name = 'name',
                text = Config.Languages[Config.Language]['name']
            },
            {
                type = 'password',
                isRequired = true,
                name = 'password',
                text = Config.Languages[Config.Language]['password']
            },
        }
    })

    if input then
        local name = input.name
        local password = input.password

        if name and tonumber(password) then
            QBCore.Functions.TriggerCallback('ggwpx-warehouse:server:BuyWarehouse', function(success)
                if success then
                    TriggerServerEvent('qb-phone:server:sendNewMail', {
                        sender = Config.Languages[Config.Language]['warehouses'],
                        subject = Config.Languages[Config.Language]['process_warehouse'],
                        message = Config.Languages[Config.Language]['warehouse_name']..': '..name..' | '..Config.Languages[Config.Language]['warehouse_password']..': '..password..' | '..Config.Languages[Config.Language]['warehouse_location']..': '..warehouse
                    })
                    QBCore.Functions.Notify(Config.Languages[Config.Language]['success'], 'success')
                else
                    QBCore.Functions.Notify(Config.Languages[Config.Language]['insufficient_funds'], 'error')
                end
            end, {
                location = warehouse,
                name = name,
                password = password,
            })
        end
    end
end)

RegisterNetEvent('ggwpx-warehouse:client:OpenWarehouseList', function(data)
    local warehouse = data.warehouse
    QBCore.Functions.TriggerCallback('ggwpx-warehouse:server:GetWarehouse', function(result)
        if not result or #result == 0 then 
            QBCore.Functions.Notify(Config.Languages[Config.Language]['none_warehouse'], 'error')
        else
            local menu = {
                {
                    header = Config.Languages[Config.Language]['warehouse_list'],
                    isMenuHeader = true
                },
            }

            for _, v in pairs(result) do
                table.insert(menu, {
                    header = v.name,
                    txt = v.citizenid,
                    params = {
                        event = 'ggwpx-warehouse:client:OpenWarehouse',
                        args = {
                            v = v,
                        }
                    }
                })
            end

            exports['qb-menu']:openMenu(menu)
        end
    end, warehouse)
end)

RegisterNetEvent('ggwpx-warehouse:client:MyWarehouseList', function(data)
    local warehouse = data.warehouse
    QBCore.Functions.TriggerCallback('ggwpx-warehouse:server:GetWarehouseCitizenId', function(result)
        if not result then
            QBCore.Functions.Notify(Config.Languages[Config.Language]['none_warehouse'], 'error')
        else
            local menu = {
                {
                    header = Config.Languages[Config.Language]['my_warehouse'],
                    isMenuHeader = true
                },
            }
            if type(result) == 'table' then
                table.insert(menu, {
                    header = result.name,
                    txt = result.citizenid,
                    params = {
                        event = 'ggwpx-warehouse:client:MyWarehouse',
                        args = {
                            warehouse = result,
                        }
                    }
                })
            end

            exports['qb-menu']:openMenu(menu)
        end
    end, warehouse)
end)

RegisterNetEvent('ggwpx-warehouse:client:MyWarehouse', function(data)
    local warehouse = data.warehouse

    exports['qb-menu']:openMenu({
        {
            header = warehouse.name,
            isMenuHeader = true,
        },
        {
            header = Config.Languages[Config.Language]['view_warehouse'],
            txt = Config.Languages[Config.Language]['open_warehouse'],
            params = {
                event = 'ggwpx-warehouse:client:OpenWarehouse',
                args = {
                    v = warehouse,
                }
            }
        },
        {
            header = Config.Languages[Config.Language]['delete_warehouse_button'],
            txt = Config.Languages[Config.Language]['delete_warehouse_button'],
            params = {
                event = 'ggwpx-warehouse:client:RemoveWarehouse',
                args = {
                    v = warehouse,
                }
            }
        },
    })
end)

RegisterNetEvent('ggwpx-warehouse:client:OpenWarehouse', function(data)
    local v = data.v

    local input = exports['qb-input']:ShowInput({
        header = v.name,
        submitText = Config.Languages[Config.Language]['submit'],
        inputs = {
            {
                type = 'password',
                isRequired = true,
                name = 'password',
                text = Config.Languages[Config.Language]['password']
            },
        }
    })

    if input then
        local password = input.password

        if tonumber(password) and password == tostring(v.password) then
            TriggerServerEvent('inventory:server:OpenInventory', 'stash', 'Warehouse_'..v.location..'_'..v.name)
            TriggerEvent('inventory:client:SetCurrentStash', 'Warehouse_'..v.location..'_'..v.name)
        else
            QBCore.Functions.Notify(Config.Languages[Config.Language]['password_error'], 'error')
        end
    end
end)

RegisterNetEvent('ggwpx-warehouse:client:RemoveWarehouse', function(data)
    local v = data.v

    -- Menggunakan qb-input untuk memasukkan password
    local input = exports['qb-input']:ShowInput({
        header = Config.Languages[Config.Language]['delete_warehouse'],
        submitText = Config.Languages[Config.Language]['submit'],
        inputs = {
            {
                type = 'password',
                isRequired = true,
                name = 'password',
                text = Config.Languages[Config.Language]['password']
            },
        }
    })

    if input then
        local password = input.password

        if tonumber(password) and password == tostring(v.password) then
            TriggerServerEvent('ggwpx-warehouse:server:RemoveWarehouse', v)
            QBCore.Functions.Notify(Config.Languages[Config.Language]['warehouse_removed'], 'success')
        else
            QBCore.Functions.Notify(Config.Languages[Config.Language]['password_error'], 'error')
        end
    end
end)



local blips = {} 

CreateThread(function()
    while true do
        local InRange = false
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)

        for warehouse, data in pairs(Config.Locations) do
            local coords = data['coords']
            local dist = #(pos - vector3(coords.x, coords.y, coords.z))

            if dist < 10 then
                InRange = true
                DrawMarker(2, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.25, 0.2, 0.1, 255, 255, 255, 155, 0, 0, 0, 1, 0, 0, 0)

                if dist < 2 then
                    QBCore.Functions.DrawText3D(coords.x, coords.y, coords.z + 0.2, '[E] '..data['label'])
                    if IsControlJustPressed(0, 38) then -- Tombol E
                        TriggerEvent('ggwpx-warehouse:client:OpenMenu', warehouse)
                    end
                end
            end

            if Config.EnableBlips and data['blip'] then
                if not blips[warehouse] then
                    blips[warehouse] = AddBlipForCoord(coords.x, coords.y, coords.z)
                    SetBlipSprite(blips[warehouse], 478) 
                    SetBlipColour(blips[warehouse], 2)  
                    SetBlipAsShortRange(blips[warehouse], true)
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentString(data['label'])
                    EndTextCommandSetBlipName(blips[warehouse])
                end
            elseif blips[warehouse] then
                RemoveBlip(blips[warehouse])
                blips[warehouse] = nil
            end
        end

        if not InRange then
            Wait(2000)
        end
        Wait(5)
    end
end)

