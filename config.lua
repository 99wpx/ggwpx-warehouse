Config = Config or {}

Config.EnableBlips = true

Config.Locations = {
    [1] = {
        ['label'] = 'Warehouse 1',
        ['coords'] = vector3(55.4919, 6472.1157, 31.4253),
        ['price'] = 1000,
        ['blip'] = true,
    },
    [2] = {
        ['label'] = 'Warehouse 2',
        ['coords'] = vector3(1726.6542, 3705.5979, 34.1301),
        ['price'] = 1000,
        ['blip'] = true,
    },
    [3] = {
        ['label'] = 'Warehouse 3',
        ['coords'] = vector3(-670.6434, -2392.4180, 13.9445),
        ['price'] = 1000,
        ['blip'] = true,
    }
}

Config.Language = 'en'
Config.Languages = {
    ['en'] = {
        -- server
        ['remove_warehouse'] = 'Warehouse removed successfully.', 
        ['warehouse_not_found'] = 'Warehouse not found.', 
        ['player_not_found'] = 'Player not found.', 
        ['db_insert_error'] = 'Error inserting warehouse into the database.',
        ['warehouse_purchased'] = 'Warehouse purchased successfully.', 
        -- client
        ['warehouses'] = 'Warehouses',
        ['warehouse_list'] = 'Show warehouses list.',
        ['buy_warehouse'] = 'Buy Warehouses',
        ['buy_a_warehouse'] = 'Buy a warehouse.',
        ['my_warehouse'] = 'My Warehouse',
        ['my_warehouse_list'] = 'Show my warehouse list.',
        ['name'] = 'Name',
        ['password'] = 'Password',
        ['submit'] = 'Submit', 
        ['process_warehouse'] = 'Warehouse buying process',
        ['warehouse_name'] = 'Warehouse Name',
        ['warehouse_password'] = 'Warehouse Password',
        ['warehouse_removed'] = 'Warehouse Removed',
        ['warehouse_location'] = 'Warehouse Location',
        ['success'] = 'Warehouse purchased successfully!', 
        ['none_warehouse'] = 'There are no warehouses at this location.',
        ['view_warehouse'] = 'View Warehouse',
        ['delete_warehouse_button'] = 'Delete Warehouse',
        ['delete_warehouse'] = 'Delete Warehouse forever.',
        ['password_error'] = 'Incorrect password.', 
        ['open_warehouse'] = 'Open Warehouse',
        ['insufficient_funds'] = 'Insufficient funds in your bank account.'
    }
}